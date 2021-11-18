# frozen_string_literal: true

require 'rails_helper'

RSpec.describe V2::PrintersController, type: :request, helpers: true do |_variable|
  let(:headers) { { 'CONTENT_TYPE' => 'application/vnd.api+json' } }

  it 'should allow retrieval of all printers' do
    printers = create_list(:printer, 5)
    get v2_printers_path
    expect(response).to be_successful
    expect(ActiveSupport::JSON.decode(response.body)['printers'].length).to eq(printers.length)
  end

  it 'should allow creation of a new printer' do
    expect do
      post v2_printers_path, params: { data: { attributes: attributes_for(:printer) } }.to_json, headers: headers
    end.to change(Printer, :count).by(1)
    expect(response).to be_successful
    expect(response).to have_http_status(:created)
  end

  it 'allows creation of a printer with a specified protocol and printer_type`' do
    expect do
      post v2_printers_path, params: { data: { attributes: { name: 'Printer Juan', protocol: 'IPP', printer_type: 'squix' } } }.to_json, headers: headers
    end.to change(Printer, :count).by(1)
    expect(response).to be_successful
    expect(response).to have_http_status(:created)

    json = ActiveSupport::JSON.decode(response.body)

    expect(json['data']['attributes']['protocol']).to eq('IPP')
    expect(json['data']['attributes']['printer_type']).to eq('squix')
  end

  it 'should prevent creation of a new printer with invalid attributes' do
    expect do
      post v2_printers_path, params: { data: { attributes: { name: nil } } }.to_json, headers: headers
    end.to_not change(Printer, :count)

    expect(response).to have_http_status(:unprocessable_entity)

    json = ActiveSupport::JSON.decode(response.body)

    expect(json['errors']).not_to be_empty
    expect(find_attribute_error_details(json, 'name')).to include("can't be blank")
  end
end
