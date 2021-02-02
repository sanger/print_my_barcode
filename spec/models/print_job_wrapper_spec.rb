# frozen_string_literal: true

require 'rails_helper'

# What I did:
# used the printer type factories
# renamed print_job_wrapper to print_job_wrapper feels better semantically
# added tests to check validity of print_job_wrapper
# modified tests which seem to be mocking out the print jobs as we need to check the validity of the print_jobs themselves.
# changed labels to what should be expected
# changed assert_equal to rspec expect syntax
# took copies out of everything except first test
# did a bit of stuff with copies as it should not be required
# changed copies to a different number as from what I understand it defaults to 1
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
