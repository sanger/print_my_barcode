# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Squix::PrintJob do

  let!(:printer)            { create(:printer) }
  let(:label_template)      { create(:label_template) }
  let(:label1)               { { 'test_attr': 'test1', 'barcode': '11111', 'label_name': 'location1' } }
  let(:label2)               { { 'test_attr': 'test2', 'barcode': '22222', 'label_name': 'location2' } }
  let(:labels)              { [label1, label2] }
  let(:copies)              { 1 }
  let(:attributes)          { { printer_name: printer.name, label_template_name: label_template.name, labels: labels, copies: copies } }

  describe 'new' do
    it 'will have the correct instance variables' do
      print_job = Squix::PrintJob.new(attributes)

      expect(print_job.printer_name).to eq(printer.name)
      expect(print_job.label_template_name).to eq(label_template.name)
      expect(print_job.labels).to eq(labels)
      expect(print_job.copies).to eq(copies)
    end

    it 'will not be valid without the printer name' do
      print_job = Squix::PrintJob.new(attributes.except(:printer_name))
      expect(print_job).to_not be_valid
    end

    it 'will not be valid without the label_template_name' do
      print_job = Squix::PrintJob.new(attributes.except(:label_template_name))
      expect(print_job).to_not be_valid
    end

    it 'will not be valid without the labels' do
      print_job = Squix::PrintJob.new(attributes.except(:labels))
      expect(print_job).to_not be_valid
    end
  end

  describe '#execute' do
    context 'success' do
      it 'sends a print request and returns true' do
        print_job = Squix::PrintJob.new(attributes)
        allow(SPrintClient).to receive(:send_print_request).and_return Net::HTTPResponse.new('1.1', "200", "")
        expect(SPrintClient).to receive(:send_print_request).with(print_job.printer_name, "#{print_job.label_template_name}.yml.erb", print_job.merge_fields_list)
        result = print_job.execute
        expect(result).to eq true
      end
    end

    context 'failure' do
      it 'sends a print request and returns false' do
        print_job = Squix::PrintJob.new(attributes)
        allow(SPrintClient).to receive(:send_print_request).and_return Net::HTTPResponse.new('1.1', "422", "an error")
        expect(SPrintClient).to receive(:send_print_request).with(print_job.printer_name, "#{print_job.label_template_name}.yml.erb", print_job.merge_fields_list)
        result = print_job.execute
        expect(result).to eq false
      end
    end
  end

  describe '#merge_fields_list' do
    it 'will return the correct number of merge fields when copies is more than 1' do
      print_job = Squix::PrintJob.new(attributes.merge(copies: 2))
      expected = print_job.converted_labels
      expect(print_job.merge_fields_list).to eq(expected * 2)
    end
  end

end
