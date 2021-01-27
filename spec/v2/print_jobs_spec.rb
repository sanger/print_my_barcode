# frozen_string_literal: true

require 'rails_helper'

RSpec.describe V2::PrintJobsController, type: :request, helpers: true do

  let!(:printer)          { create(:printer) }
  let!(:label_template)   { create(:label_template) }
  let(:labels)            { [{ 'test_attr' => 'test', 'barcode' => '12345' }] }
  let(:copies)            { 1 }

  it 'should print a valid label' do
    body = { printer_name: printer.name, label_template_name: label_template.name, label_template_id: label_template.id, labels: labels, copies: copies }
    post v2_print_jobs_path, params: { print_job: body }
    expect(response).to be_successful
    expect(response).to have_http_status(:success)
    json = ActiveSupport::JSON.decode(response.body)
    expect(json['message']).to eq('labels successfully printed')
  end

  # TODO: fix
  xit 'should return an error if request provides incorrect parameters' do
    post v2_print_jobs_path, params: { print_job: { printer_name: printer.name } }
    expect(response).to_not be_successful
    expect(response).to have_http_status(:unprocessable_entity)

    json = ActiveSupport::JSON.decode(response.body)

    expect(json['errors']).not_to be_empty
    expect(find_attribute_error_details(json, 'label_template')).to include('does not exist')
  end
end