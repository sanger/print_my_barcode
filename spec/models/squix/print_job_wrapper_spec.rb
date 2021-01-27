# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Squix::PrintJobWrapper do

  let!(:printer)          { create(:printer) }
  let(:label_template)      { create(:label_template) }
  let(:labels)              { [{ 'label' => { 'test_attr' => 'test', 'barcode' => '12345' } }] }
  let(:copies)   { 1 }

  describe 'init' do
    it 'has the correct insatnce variables' do
      pjw = Squix::PrintJobWrapper.new(printer.name, label_template.name, label_template.id, labels, copies)

      assert_equal printer.name, pjw.printer_name
      assert_equal label_template.id, pjw.label_template_id
      assert_equal label_template.name, pjw.label_template_name
      assert_equal labels, pjw.labels
      assert_equal copies, pjw.copies
    end
  end

  describe 'print' do
    it 'calls print_to_toshiba when printer_type is Toshiba' do
      pjw = Squix::PrintJobWrapper.new(printer.name, label_template.name, label_template.id, labels, copies)
      allow(pjw).to receive(:printer_type).and_return('Toshiba')

      expect(pjw).to receive(:print_to_toshiba)
      pjw.print
    end

    it 'calls print_to_sprint when service is Squix' do
      pjw = Squix::PrintJobWrapper.new(printer.name,label_template.name, label_template.id, labels, copies)
      allow(pjw).to receive(:printer_type).and_return('Squix')

      expect(pjw).to receive(:print_to_squix)
      pjw.print
    end

    it 'adds an error when service is down' do
      pjw = Squix::PrintJobWrapper.new(printer.name,label_template.name, label_template.id, labels, copies)
      allow(pjw).to receive(:printer_type).and_return('Unknown')

      expect(pjw).not_to receive(:print_to_toshiba)
      expect(pjw).not_to receive(:print_to_squix)
      # expect(pjw.errors).to match /Printer type not recognised./
      pjw.print
    end
  end

  describe 'print_to_toshiba' do
    describe 'when label_template id is not present' do
      it 'builds a LabelPrinter::PrintJob with the correct arributes and executes' do
        label_template = create(:label_template)
        print_job = build(:print_job)
        pjw = Squix::PrintJobWrapper.new(printer.name, label_template.name, nil, labels, copies)

        allow(LabelPrinter::PrintJob).to receive(:build).and_return(print_job)

        expected_body = { label_template_id: label_template.id, labels: labels, printer_name: printer.name }
        expect(LabelPrinter::PrintJob).to receive(:build).with(expected_body)
        expect(print_job).to receive(:execute)
        pjw.print_to_toshiba
      end
    end

    describe 'when label_template id is present' do
      it 'builds a LabelPrinter::PrintJob with the correct arributes' do
        print_job = build(:print_job)
        pjw = Squix::PrintJobWrapper.new(printer.name, nil, label_template.id, labels, copies)

        allow(LabelPrinter::PrintJob).to receive(:build).and_return(print_job)

        expected_body = { label_template_id: label_template.id, labels: labels, printer_name: printer.name }
        expect(LabelPrinter::PrintJob).to receive(:build).with(expected_body)
        expect(print_job).to receive(:execute)

        pjw.print_to_toshiba
      end
    end
  end

  describe 'print_to_squix' do
    it 'builds a Squix::PrintJob with the correct arributes' do
      squix_print_job = build(:squix_print_job)
      pjw = Squix::PrintJobWrapper.new(printer.name, label_template.name, label_template.id, labels, copies)

      allow(Squix::PrintJob).to receive(:new).and_return(squix_print_job)

      expected_body = { printer_name: printer.name, label_template_name: label_template.name, labels: labels, copies: copies }
      expect(Squix::PrintJob).to receive(:new).with(expected_body)
      expect(squix_print_job).to receive(:execute)

      pjw.print_to_squix
    end
  end

  describe 'create_response' do
  end

  describe 'get_printer_type' do
    # TODO GPL-831-2
    it 'returns the correct printer type' do
    end
  end
end