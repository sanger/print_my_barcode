# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Squix::PrintJob do

  let!(:printer)          { create(:printer) }
  let(:label_template)      { create(:label_template) }
  let(:labels)              { [{ 'label' => { 'test_attr' => 'test', 'barcode' => '12345' } }] }
  let(:copies)   { 1 }

  describe 'init' do
    it 'has the correct insatnce variables' do
      pj = Squix::PrintJob.new(printer_name: printer.name, label_template_name: label_template.name, labels: labels, copies: copies)

      assert_equal printer.name, pj.printer_name
      assert_equal label_template.name, pj.label_template_name
      assert_equal labels, pj.labels
      assert_equal copies, pj.copies
    end
  end

  describe '#execute' do
    it 'sends a print request' do
      pj = Squix::PrintJob.new(printer_name: printer.name, label_template_name: label_template.name, labels: labels, copies: copies)
      expect(SPrintClient).to receive(:send_print_request).with(pj.printer_name, pj.label_template_name, pj.merge_fields_list)
      pj.execute
    end
  end

  describe '#merge_fields_list' do
    it 'returns the same when copies is 1' do
      pj = Squix::PrintJob.new(printer_name: printer.name, label_template_name: label_template.name, labels: labels, copies: 2)
      expect(pj.merge_fields_list).to eq [{ 'label' => { 'test_attr' => 'test', 'barcode' => '12345' } }, { 'label' => { 'test_attr' => 'test', 'barcode' => '12345' } }]
    end
  end

end
