# frozen_string_literal: true

require 'rails_helper'

RSpec.describe PrintJobWrapper do

  let!(:squix_printer)      { create(:squix_printer) }
  let!(:toshiba_printer)    { create(:toshiba_printer) }
  let(:label_template)      { create(:label_template) }
  let(:labels)              { [{ 'test_attr' => 'test', 'barcode' => '11111', 'label_name': 'location' }, { 'test_attr' => 'test2', 'barcode' => '22222', 'label_name': 'location2' }] }
  let(:copies)              { 2 }
  let(:attributes)          { { printer_name: toshiba_printer.name, label_template_name: label_template.name, labels: labels, copies: copies } }

  describe 'new' do
    it 'has the correct instance variables' do
      print_job_wrapper = PrintJobWrapper.new(attributes)

      expect(print_job_wrapper.printer).to eq(toshiba_printer)
      expect(print_job_wrapper.label_template).to eq(label_template)
      expect(print_job_wrapper.labels).to eq(labels)
      expect(print_job_wrapper.copies).to eq(copies)
    end

    it 'will be valid with the correct instance variables' do
      expect(PrintJobWrapper.new(attributes)).to be_valid
    end

    it 'is not valid without a printer name' do
      expect(PrintJobWrapper.new(attributes.except(:printer_name))).to_not be_valid
    end

    it 'is not valid without a label template name' do
      expect(PrintJobWrapper.new(attributes.except(:label_template_name))).to_not be_valid
    end

    it 'is not valid without some labels' do
      expect(PrintJobWrapper.new(attributes.except(:labels))).to_not be_valid
    end

    it 'will be valid if copies is not passed' do
      print_job_wrapper = PrintJobWrapper.new(attributes.except(:copies))
      expect(print_job_wrapper).to be_valid
      expect(print_job_wrapper.copies).to be_present
    end
  end

  describe '#print_job' do

    context 'Toshiba' do
      it 'creates a new print job of the correct type' do
        print_job_wrapper = PrintJobWrapper.new(attributes.merge(labels: labels))
        expect(print_job_wrapper.print_job).to be_instance_of(LabelPrinter::PrintJob::LPD)
      end

      it 'will not execute if the print job is not valid' do
        print_job_wrapper = PrintJobWrapper.new(attributes.except(:labels))
        expect(print_job_wrapper).to_not be_valid
        expect(print_job_wrapper.print).to be_falsy
      end

      it 'will execute the print job if it is valid' do
        print_job_wrapper = PrintJobWrapper.new(attributes)
        allow(print_job_wrapper.print_job).to receive(:execute).and_return(true)
        expect(print_job_wrapper).to be_valid
        expect(print_job_wrapper.print).to be_truthy
      end
    end

    context 'Squix' do
      it 'creates a new print job of the correct type' do
        print_job_wrapper = PrintJobWrapper.new(attributes.merge(printer_name: squix_printer.name))
        expect(print_job_wrapper.print_job).to be_instance_of(Squix::PrintJob)
      end

      it 'will not execute if the print job is not valid' do
        print_job_wrapper = PrintJobWrapper.new(attributes.except(:labels).merge(printer_name: squix_printer.name))
        expect(print_job_wrapper.print_job).to_not be_valid
        expect(print_job_wrapper.print).to be_falsy
      end

      it 'will execute the print job if it is valid' do
        print_job_wrapper = PrintJobWrapper.new(attributes.merge(printer_name: squix_printer.name))
        allow(print_job_wrapper.print_job).to receive(:execute).and_return(true)
        expect(print_job_wrapper).to be_valid
        expect(print_job_wrapper.print).to be_truthy
      end
    end
  end

end
