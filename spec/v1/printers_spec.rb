# frozen_string_literal: true

require 'rails_helper'

RSpec.describe V1::PrintersController, type: :request, helpers: true do |_variable|
  let(:headers) { { 'CONTENT_TYPE' => 'application/vnd.api+json' } }

  it 'should allow retrieval of all printers' do
    printers = create_list(:printer, 5)
    get v1_printers_path
    expect(response).to be_successful
    expect(ActiveSupport::JSON.decode(response.body)['data'].length).to eq(printers.length)
  end

  it 'filters printers by name' do
    printers = create_list(:printer, 5)
    printer = printers.first

    get "#{v1_printers_path}?filter[name]=#{printer.name}"

    expect(response).to be_successful
    json = ActiveSupport::JSON.decode(response.body)

    expect(json['data'].length).to eq(1)
    expect(json['data'][0]['id']).to eq(printer.id.to_s)
    expect(json['data'][0]['attributes']['name']).to eq(printer.name)
  end

  it 'filters printers by protocol' do
    create_list(:printer, 3, protocol: 'LPD')
    create_list(:printer, 3, protocol: 'IPP')

    get "#{v1_printers_path}?filter[protocol]=LPD"

    expect(response).to be_successful
    json = ActiveSupport::JSON.decode(response.body)

    expect(json['data'].length).to eq(3)
    expect(json['data'][0]['attributes']['protocol']).to eq('LPD')
    expect(json['data'][1]['attributes']['protocol']).to eq('LPD')
    expect(json['data'][2]['attributes']['protocol']).to eq('LPD')
  end

  it 'should allow retrieval of information about a particular printer' do
    printer = create(:printer)
    get v1_printer_path(printer)
    expect(response).to be_successful
    json = ActiveSupport::JSON.decode(response.body)['data']
    json_attributes = json['attributes']
    expect(json['id'].to_i).to eq(printer.id)
    expect(json_attributes['name']).to eq(printer.name)
  end

  it 'should allow creation of a new printer' do
    expect do
      post v1_printers_path, params: { data: { attributes: attributes_for(:printer) } }.to_json, headers: headers
    end.to change(Printer, :count).by(1)
    expect(response).to be_successful
    expect(response).to have_http_status(:created)
  end

  it 'allows creation of a printer with a specified protocol' do
    expect do
      post v1_printers_path, params: { data: { attributes: { name: 'Printer Juan', protocol: 'IPP' } } }.to_json, headers: headers
    end.to change(Printer, :count).by(1)
    expect(response).to be_successful
    expect(response).to have_http_status(:created)

    json = ActiveSupport::JSON.decode(response.body)

    expect(json['data']['attributes']['protocol']).to eq('IPP')
  end

  it 'should prevent creation of a new printer with invalid attributes' do
    expect do
      post v1_printers_path, params: { data: { attributes: { name: nil } } }.to_json, headers: headers
    end.to_not change(Printer, :count)

    expect(response).to have_http_status(:unprocessable_entity)

    json = ActiveSupport::JSON.decode(response.body)

    expect(json['errors']).not_to be_empty
    expect(find_attribute_error_details(json, 'name')).to include("can't be blank")
  end
end
