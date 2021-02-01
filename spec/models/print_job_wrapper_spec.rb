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
  let(:labels)              { [{ 'test_attr' => 'test', 'barcode' => '12345' }] }
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

      let(:toshiba_labels) { label_template.dummy_labels.to_h }
      
      xit 'creates a new print job of the correct type' do
        print_job_wrapper = PrintJobWrapper.new(attributes.merge(labels: toshiba_labels))
        expect(print_job_wrapper.print_job).to be_instance_of(LabelPrinter::PrintJob::LPD)
      end

      xit 'is not valid if the print job is not valid' do
        print_job_wrapper = PrintJobWrapper.new(attributes.except(:labels))
        expect(print_job_wrapper.print_job).to_not be_valid
      end

      xit 'will execute the print job if it is valid' do
        print_job_wrapper = PrintJobWrapper.new(attributes.merge(printer_name: squix_printer.name))
        allow(print_job_wrapper.print_job).to receive(:execute).and_return(true)
        expect(print_job_wrapper.execute).to be_truthy
        expect(print_job_wrapper.print_job).to receive(:execute)
      end
    end

    context 'Squix' do
      xit 'creates a new print job of the correct type' do
        print_job_wrapper = PrintJobWrapper.new(attributes.merge(printer_name: squix_printer.name))
        expect(print_job_wrapper.print_job).to be_instance_of(Squix::PrintJob)
      end

      xit 'is not valid if the print job is not valid' do
        print_job_wrapper = PrintJobWrapper.new(attributes.except(:labels))
        expect(print_job_wrapper.print_job).to_not be_valid
      end

      xit 'will execute the print job if it is valid' do
        print_job_wrapper = PrintJobWrapper.new(attributes.merge(printer_name: squix_printer.name))
        allow(print_job_wrapper.print_job).to receive(:execute).and_return(true)
        expect(print_job_wrapper.execute).to be_truthy
        expect(print_job_wrapper.print_job).to receive(:execute)
      end
    end
  end

  # describe '#print_job' do
  #   it 'sets the print job for a Toshiba printer' do
  #     body = { printer_name: toshiba_printer.name, label_template_id: label_template.id, labels: labels }
  #     print_job_wrapper = PrintJobWrapper.new(body)
  #     toshiba_print_job = LabelPrinter::PrintJob.build(body)

  #     allow(print_job_wrapper).to receive(:toshiba_print_job).and_return(toshiba_print_job)
  #     expect(print_job_wrapper.print_job).to eq print_job_wrapper.toshiba_print_job
  #   end

  #   it 'sets the print job for a Squix printer' do
  #     body = { printer_name: squix_printer.name, label_template_name: label_template.name, labels: labels }
  #     print_job_wrapper = PrintJobWrapper.new(body)
  #     squix_print_job = Squix::PrintJob.new(body)

  #     allow(print_job_wrapper).to receive(:squix_print_job).and_return(squix_print_job)
  #     expect(print_job_wrapper.print_job).to eq print_job_wrapper.squix_print_job
  #   end
  # end

  # describe '#print' do
  #   context 'when printer_type is Toshiba' do
  #     it 'validates the print job and calls execute when valid' do
  #       body = { printer_name: toshiba_printer.name, label_template_id: label_template.id, labels: labels }

  #       print_job_wrapper = PrintJobWrapper.new(body)
  #       toshiba_print_job = LabelPrinter::PrintJob.build(body)

  #       allow(print_job_wrapper).to receive(:toshiba_print_job).and_return(toshiba_print_job)
  #       allow(toshiba_print_job).to receive(:execute)

  #       print_job_wrapper.print
  #       expect(toshiba_print_job.valid?).to eq true
  #     end

  #     it 'validates the print job and returns false when invalid' do
  #       body_missing_attribute = { printer_name: toshiba_printer.name, labels: labels }

  #       print_job_wrapper = PrintJobWrapper.new(body_missing_attribute)
  #       toshiba_print_job = LabelPrinter::PrintJob.build(body_missing_attribute)

  #       allow(print_job_wrapper).to receive(:toshiba_print_job).and_return(toshiba_print_job)
  #       allow(toshiba_print_job).to receive(:execute)

  #       print_job_wrapper.print
  #       expect(toshiba_print_job.valid?).to eq false
  #       expect(toshiba_print_job.errors.messages).to eq({ label_template: ["does not exist"] })
  #     end
  #   end

  #   context 'when printer_type is Squix' do
  #     it 'validates the print job and calls execute when valid' do
  #       body = { printer_name: squix_printer.name, label_template_name: label_template.name, labels: labels }
  #       print_job_wrapper = PrintJobWrapper.new(body)
  #       squix_print_job = Squix::PrintJob.new(body)

  #       allow(print_job_wrapper).to receive(:squix_print_job).and_return(squix_print_job)
  #       allow(squix_print_job).to receive(:execute)

  #       print_job_wrapper.print
  #       expect(squix_print_job.valid?).to eq true
  #     end

  #     it 'validates the print job and returns false when invalid' do
  #       body_missing_attribute = { printer_name: squix_printer.name, labels: labels }
  #       print_job_wrapper = PrintJobWrapper.new(body_missing_attribute)
  #       squix_print_job = Squix::PrintJob.new(body_missing_attribute)

  #       allow(print_job_wrapper).to receive(:squix_print_job).and_return(squix_print_job)
  #       allow(squix_print_job).to receive(:execute)

  #       print_job_wrapper.print
  #       expect(squix_print_job.valid?).to eq false
  #       expect(squix_print_job.errors.messages).to eq({ label_template_name: ["can't be blank"] })
  #     end
  #   end
  # end

  # describe '#toshiba_print_job' do
  #   it 'builds a LabelPrinter::PrintJob when label_template_id is provided' do
  #     body = { printer_name: toshiba_printer.name, label_template_id: label_template.id, labels: labels }
  #     print_job_wrapper = PrintJobWrapper.new(body)
  #     expect(print_job_wrapper.toshiba_print_job).to be_instance_of(LabelPrinter::PrintJob::LPD)
  #   end

  #   it 'builds a LabelPrinter::PrintJob when label_template_name is provided' do
  #     body = { printer_name: toshiba_printer.name, label_template_name: label_template.name, labels: labels }
  #     print_job_wrapper = PrintJobWrapper.new(body)
  #     expect(print_job_wrapper.toshiba_print_job).to be_instance_of(LabelPrinter::PrintJob::LPD)
  #   end
  # end

  # describe '#squix_print_job' do
  #   it 'builds a Squix::PrintJob' do
  #     body = { printer_name: squix_printer.name, label_template_name: label_template.name, label_template_id: label_template.id, labels: labels }
  #     print_job_wrapper = PrintJobWrapper.new(body)
  #     expect(print_job_wrapper.squix_print_job).to be_instance_of(Squix::PrintJob)
  #   end
  # end

  # describe '#print_job_body' do
  #   it 'sets the print_job_body for a Toshiba printer' do
  #     body = { printer_name: toshiba_printer.name, label_template_name: label_template.name, labels: labels }
  #     print_job_wrapper = PrintJobWrapper.new(body)
  #     expect(print_job_wrapper.print_job_body.keys).to eq [:printer_name, :label_template_id, :labels]
  #   end

  #   it 'sets the print_job_body for a Squix printer' do
  #     body = { printer_name: squix_printer.name, label_template_name: label_template.name, label_template_id: label_template.id, labels: labels }
  #     print_job_wrapper = PrintJobWrapper.new(body)
  #     expect(print_job_wrapper.print_job_body.keys).to eq [:printer_name, :label_template_name, :labels, :copies]
  #   end
  # end

  # describe '#printer' do
  #   it 'returns the correct printer' do
  #     body = { printer_name: squix_printer.name, label_template_name: label_template.name, label_template_id: label_template.id, labels: labels }
  #     print_job_wrapper = PrintJobWrapper.new(body)
  #     expect(print_job_wrapper.printer).to eq squix_printer
  #   end
  # end
end
