# frozen_string_literal: true

require 'rails_helper'

RSpec.describe LabelPrinter::PrintJob, type: :model do
  let!(:printer)                { create(:printer) }
  let!(:label_template)         { create(:label_template) }
  let!(:labels_for_v2)          { [{ "barcode": "aBarcode1", "parent_location": "aParentLocation1", "location": "location1", "label_name": "location_label_name_1"}, {"barcode": "aBarcode2", "parent_location": "aParentLocation2", "location": "location2", "label_name": "location_label_name_2"}] }
  let!(:expected_labels_for_v2) { { "body": [{"location_label_name_1": {"barcode": "aBarcode1", "parent_location": "aParentLocation1", "location": "location1"}}, {"location_label_name_2": {"barcode": "aBarcode2", "parent_location": "aParentLocation2", "location"=>"location2"}}] }.with_indifferent_access }

  it 'should have a printer' do
    expect(build(:print_job, printer_name: printer.name)).to be_valid
    expect(build(:print_job, printer_name: nil)).to_not be_valid
    expect(build(:print_job, printer_name: 999)).to_not be_valid
  end

  it 'should have a label template' do
    expect(build(:print_job, printer_name: printer.name, label_template_id: nil)).to_not be_valid
    expect(build(:print_job, label_template_id: 999)).to_not be_valid
  end

  it 'should have some values' do
    expect(build(:print_job, label_template_id: label_template.id, labels: label_template.dummy_labels.to_h)).to be_valid
    expect(build(:print_job, labels: nil)).to_not be_valid
    expect(build(:print_job, labels: {})).to_not be_valid
  end

  it 'should print the label if it is valid' do
    print_job = LabelPrinter::PrintJob.build(printer_name: printer.name, label_template_id: label_template.id, labels: label_template.dummy_labels.to_h)
    allow(print_job).to receive(:execute).and_return(true)
    expect(print_job.execute).to be_truthy
  end

  it 'should not print the label if it is not valid' do
    print_job = LabelPrinter::PrintJob.build(printer_name: printer.name, label_template_id: 999, labels: label_template.dummy_labels.to_h)
    allow(print_job).to receive(:execute).and_return(false)
    expect(print_job.execute).to be_falsey
  end

  it 'with valid data should carry out the print job' do
    print_job = LabelPrinter::PrintJob::LPD.new(printer_name: printer.name, label_template_id: label_template.id, labels: label_template.dummy_labels.to_h)
    allow(print_job).to receive(:system)
    expect(print_job.execute).to be_truthy
  end

  it 'with invalid data should not carry out the print job' do
    print_job = LabelPrinter::PrintJob::LPD.new(printer_name: printer.name, label_template_id: label_template.id, labels: {})
    expect(print_job).to_not be_valid
    expect(print_job.execute).to be_falsey
  end

  it 'with a particular protocol should build a print job of the correct class' do
    print_job = LabelPrinter::PrintJob.build(printer_name: printer.name, label_template_id: label_template.id, labels: label_template.dummy_labels.to_h)
    expect(print_job).to be_LPD
    print_job = LabelPrinter::PrintJob.build(printer_name: create(:printer, protocol: 'IPP').name, label_template_id: label_template.id, labels: label_template.dummy_labels.to_h)
    expect(print_job).to be_IPP
  end

  describe '#convert_labels' do
    it 'converts the labels as expected' do
      output = LabelPrinter::PrintJob.convert_labels(labels_for_v2)

      expect(output[:body]).to be_present
      expect(output[:body].length).to eq 2
      expect(output[:body][0]['location_label_name_1']).to be_present
      expect(output[:body][1]['location_label_name_2']).to be_present
    end
  end

  describe '#build_from_v2' do
    it 'calls convert_labels' do
      print_job = LabelPrinter::PrintJob.build_from_v2(printer_name: printer.name, label_template_id: label_template.id, labels: labels_for_v2)
      expect(print_job.labels.with_indifferent_access).to eq expected_labels_for_v2
      expect(print_job).to be_valid
    end
  end
end
