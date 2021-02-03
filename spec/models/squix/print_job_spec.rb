# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Squix::PrintJob do

  let!(:printer)            { create(:printer) }
  let(:label_template)      { create(:label_template) }
  let(:label)               { { 'test_attr' => 'test', 'barcode' => '12345' } }
  let(:labels)              { [label] }
  let(:copies)              { 1 }
  let(:attributes)          { { printer_name: printer.name, label_template_name: label_template.name, labels: [label], copies: copies } }

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
    it 'sends a print request' do
      print_job = Squix::PrintJob.new(attributes)
      expect(SPrintClient).to receive(:send_print_request).with(print_job.printer_name, print_job.label_template_name, print_job.merge_fields_list)
      print_job.execute
    end
  end

  describe '#merge_fields_list' do
    it 'will return the correct number of merge fields when copies is more than 1' do
      print_job = Squix::PrintJob.new(attributes.merge(copies: 2))
      expect(print_job.merge_fields_list).to eq([label] * 2)
    end
  end

end
