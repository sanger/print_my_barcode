# frozen_string_literal: true

require 'rails_helper'

RSpec.describe V2::PrintJobsController, type: :request, helpers: true do

  let!(:squix_printer)    { create(:printer, printer_type: :squix) }
  let!(:toshiba_printer)  { create(:printer, printer_type: :toshiba) }
  let!(:label_template)   { create(:label_template_simple) }
  let(:labels)            { label_template.dummy_labels.to_h[:body].collect { |label| label.collect { |k,v| v.merge(label_name: k)}}.flatten }
  let(:copies)            { '1' }

  describe 'On success' do
    context 'When printer type is Squix' do
      it 'should send_print_request to SPrintClient ' do
        body = { printer_name: squix_printer.name, label_template_name: label_template.name, labels: labels, copies: copies }
        allow(SPrintClient).to receive(:send_print_request).and_return(true)

        post v2_print_jobs_path, params: { print_job: body }

        expect(response).to be_successful
        expect(response).to have_http_status(:success)
        json = ActiveSupport::JSON.decode(response.body)
        expect(json['message']).to eq('labels successfully printed')
      end
    end

    context 'When printer type is Toshiba' do
      it 'should send_print_request to SPrintClient ' do
        body = { printer_name: toshiba_printer.name, label_template_name: label_template.name,
        labels: labels }
        allow_any_instance_of(LabelPrinter::PrintJob::LPD).to receive(:execute).and_return(true)

        post v2_print_jobs_path, params: { print_job: body }
        expect(response).to be_successful
        expect(response).to have_http_status(:success)
        json = ActiveSupport::JSON.decode(response.body)
        expect(json['message']).to eq('labels successfully printed')
      end
    end
  end

  describe 'On failure' do
    context 'when wrapper is not valid' do
      it 'should return an error if the printer name is missing' do
        body = { printer_name: '', label_template_name: label_template.name, labels: labels }

        post v2_print_jobs_path, params: { print_job: body }
        expect(response).to have_http_status(:unprocessable_entity)

        json = ActiveSupport::JSON.decode(response.body)

        expect(json['errors']).not_to be_empty
        expect(find_attribute_error_details(json, 'printer')).to include("can't be blank")
      end
    end

    context 'when toshiba_print_job is not valid' do
      it 'should return an error' do
        body = { printer_name: toshiba_printer.name, label_template_name: '', labels: labels }

        post v2_print_jobs_path, params: { print_job: body }
        expect(response).to have_http_status(:unprocessable_entity)

        json = ActiveSupport::JSON.decode(response.body)

        expect(json['errors']).not_to be_empty
        expect(find_attribute_error_details(json, 'label_template')).to include("can't be blank")
      end
    end

    context 'when squix_print_job is not valid' do
      it 'should return an error' do
        body = { printer_name: squix_printer.name, label_template_name: '', labels: labels }

        post v2_print_jobs_path, params: { print_job: body }
        expect(response).to have_http_status(:unprocessable_entity)

        json = ActiveSupport::JSON.decode(response.body)

        expect(json['errors']).not_to be_empty
        expect(find_attribute_error_details(json, 'label_template')).to include("can't be blank")
      end
    end
  end
end