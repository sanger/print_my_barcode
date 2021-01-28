# frozen_string_literal: true

require 'rails_helper'

RSpec.describe PrintJobWrapper do

  let!(:squix_printer)       { create(:printer, printer_type: :squix) }
  let!(:toshiba_printer)     { create(:printer, printer_type: :toshiba) }
  let(:label_template)      { create(:label_template) }
  let(:labels)              { [{ 'label' => { 'test_attr' => 'test', 'barcode' => '12345' } }] }
  let(:copies)              { '1' }

  describe 'init' do
    it 'has the correct instance variables' do
      pjw = PrintJobWrapper.new({ printer_name: toshiba_printer.name, label_template_name: label_template.name, label_template_id: label_template.id, labels: labels, copies: copies })

      assert_equal toshiba_printer.name, pjw.printer_name
      assert_equal label_template.id, pjw.label_template_id
      assert_equal label_template.name, pjw.label_template_name
      assert_equal labels, pjw.labels
      assert_equal copies.to_i, pjw.copies
    end
  end

  describe '#print_job' do
    it 'sets the print job for a Toshiba printer' do
      body = { printer_name: toshiba_printer.name, label_template_id: label_template.id, labels: labels }
      pjw = PrintJobWrapper.new(body)
      toshiba_print_job = LabelPrinter::PrintJob.build(body)

      allow(pjw).to receive(:toshiba_print_job).and_return(toshiba_print_job)
      expect(pjw.print_job).to eq pjw.toshiba_print_job
    end

    it 'sets the print job for a Squix printer' do
      body = { printer_name: squix_printer.name, label_template_name: label_template.name, labels: labels, copies: copies }
      pjw = PrintJobWrapper.new(body)
      squix_print_job = Squix::PrintJob.new(body)

      allow(pjw).to receive(:squix_print_job).and_return(squix_print_job)
      expect(pjw.print_job).to eq pjw.squix_print_job
    end
  end

  describe '#print' do
    context 'when printer_type is Toshiba' do
      it 'validates the print job and calls execute when valid' do
        body = { printer_name: toshiba_printer.name, label_template_id: label_template.id, labels: labels }

        pjw = PrintJobWrapper.new(body)
        toshiba_print_job = LabelPrinter::PrintJob.build(body)

        allow(pjw).to receive(:toshiba_print_job).and_return(toshiba_print_job)
        allow(toshiba_print_job).to receive(:execute)

        pjw.print
        expect(toshiba_print_job.valid?).to eq true
      end

      it 'validates the print job and returns false when invalid' do
        body_missing_attribute = { printer_name: toshiba_printer.name, labels: labels }

        pjw = PrintJobWrapper.new(body_missing_attribute)
        toshiba_print_job = LabelPrinter::PrintJob.build(body_missing_attribute)

        allow(pjw).to receive(:toshiba_print_job).and_return(toshiba_print_job)
        allow(toshiba_print_job).to receive(:execute)

        pjw.print
        expect(toshiba_print_job.valid?).to eq false
        expect(toshiba_print_job.errors.messages).to eq({ label_template: ["does not exist"] })
      end
    end

    context 'when printer_type is Squix' do
      it 'validates the print job and calls execute when valid' do
        body = { printer_name: squix_printer.name, label_template_name: label_template.name, labels: labels, copies: copies }
        pjw = PrintJobWrapper.new(body)
        squix_print_job = Squix::PrintJob.new(body)

        allow(pjw).to receive(:squix_print_job).and_return(squix_print_job)
        allow(squix_print_job).to receive(:execute)

        pjw.print
        expect(squix_print_job.valid?).to eq true
      end

      it 'validates the print job and returns false when invalid' do
        body_missing_attribute = { printer_name: squix_printer.name, labels: labels, copies: copies }
        pjw = PrintJobWrapper.new(body_missing_attribute)
        squix_print_job = Squix::PrintJob.new(body_missing_attribute)

        allow(pjw).to receive(:squix_print_job).and_return(squix_print_job)
        allow(squix_print_job).to receive(:execute)

        pjw.print
        expect(squix_print_job.valid?).to eq false
        expect(squix_print_job.errors.messages).to eq({ label_template_name: ["can't be blank"] })
      end
    end
  end

  describe '#toshiba_print_job' do
    it 'builds a LabelPrinter::PrintJob when label_template_id is provided' do
      body = { printer_name: toshiba_printer.name, label_template_id: label_template.id, labels: labels }
      pjw = PrintJobWrapper.new(body)
      expect(pjw.toshiba_print_job).to be_instance_of(LabelPrinter::PrintJob::LPD)
    end

    it 'builds a LabelPrinter::PrintJob when label_template_name is provided' do
      body = { printer_name: toshiba_printer.name, label_template_name: label_template.name, labels: labels }
      pjw = PrintJobWrapper.new(body)
      expect(pjw.toshiba_print_job).to be_instance_of(LabelPrinter::PrintJob::LPD)
    end
  end

  describe '#squix_print_job' do
    it 'builds a Squix::PrintJob' do
      body = { printer_name: squix_printer.name, label_template_name: label_template.name, label_template_id: label_template.id, labels: labels, copies: copies }
      pjw = PrintJobWrapper.new(body)
      expect(pjw.squix_print_job).to be_instance_of(Squix::PrintJob)
    end
  end

  describe '#print_job_body' do
    it 'sets the print_job_body for a Toshiba printer' do
      body = { printer_name: toshiba_printer.name, label_template_name: label_template.name, labels: labels }
      pjw = PrintJobWrapper.new(body)
      expect(pjw.print_job_body.keys).to eq [:printer_name, :label_template_id, :labels]
    end

    it 'sets the print_job_body for a Squix printer' do
      body = { printer_name: squix_printer.name, label_template_name: label_template.name, label_template_id: label_template.id, labels: labels, copies: copies }
      pjw = PrintJobWrapper.new(body)
      expect(pjw.print_job_body.keys).to eq [:printer_name, :label_template_name, :labels, :copies]
    end
  end

  describe '#printer' do
    it 'returns the correct printer' do
      body = { printer_name: squix_printer.name, label_template_name: label_template.name, label_template_id: label_template.id, labels: labels, copies: copies }
      pjw = PrintJobWrapper.new(body)
      expect(pjw.printer).to eq squix_printer
    end
  end
end
