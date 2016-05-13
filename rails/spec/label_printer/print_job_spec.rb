require "rails_helper"

RSpec.describe LabelPrinter::PrintJob, type: :model do 

  let!(:printer)            { create(:printer) }
  let!(:label_template)     { create(:label_template) }

  it "should have a printer" do
    expect(build(:print_job, printer_name: printer.name)).to be_valid
    expect(build(:print_job, printer_name: nil)).to_not be_valid
    expect(build(:print_job, printer_name: 999)).to_not be_valid
  end

  it "should have a label template" do
    expect(build(:print_job, printer_name: printer.name, label_template_id: nil)).to_not be_valid
    expect(build(:print_job, label_template_id: 999)).to_not be_valid
  end

  it "should have some values" do
    expect(build(:print_job, label_template_id: label_template.id, labels: label_template.dummy_labels.to_h)).to be_valid
    expect(build(:print_job, labels: nil)).to_not be_valid
    expect(build(:print_job, labels: {})).to_not be_valid
  end

  it "should print the label if it is valid" do
    print_job = LabelPrinter::PrintJob.build(printer_name: printer.name, label_template_id: label_template.id, labels: label_template.dummy_labels.to_h)
    allow(print_job).to receive(:execute).and_return(true)
    expect(print_job.execute).to be_truthy
  end

  it "should not print the label if it is not valid" do
    print_job = LabelPrinter::PrintJob.build(printer_name: printer.name, label_template_id: 999, labels: label_template.dummy_labels.to_h)
    allow(print_job).to receive(:execute).and_return(false)
    expect(print_job.execute).to be_falsey
  end

  describe "LPD" do

    let(:print_job) { LabelPrinter::PrintJob.build(printer_name: printer.name, label_template_id: label_template.id, labels: label_template.dummy_labels.to_h) }

    it "should be of the correct type" do
      expect(print_job).to be_LPD
    end

    it "with valid data should carry out the print job" do
      allow(print_job).to receive(:system)
      expect(print_job.execute).to be_truthy
    end

    it "with invalid data should not carry out the print job" do
      print_job = LabelPrinter::PrintJob.build(printer_name: printer.name, label_template_id: label_template.id, labels: {})
      expect(print_job).to_not be_valid
      expect(print_job.execute).to be_falsey
    end

  end

  describe "IPP" do

    let!(:printer) { create(:printer, protocol: "IPP") }
    let(:print_job) { LabelPrinter::PrintJob.build(printer_name: printer.name, label_template_id: label_template.id, labels: label_template.dummy_labels.to_h) }

    it "should be of the correct type" do
      expect(print_job).to be_IPP
    end

    it "should have a printer uri" do
      expect(print_job.printer_uri.host).to eq(printer.name)
      expect(print_job.printer_uri.path).to eq("/ipp")
      expect(print_job.printer_uri.port).to eq(631)
    end

    it "should have the correct headers" do
      expect(print_job.headers['Content-Type']).to eq("application/ipp")
      expect(print_job.headers['Content-Length']).to eq(print_job.request_body.data_length)
    end

    it "should have a valid request body" do
      expect(print_job.request_body).to be_valid
    end

    it "with invalid data should not carry out the print job" do
      print_job = LabelPrinter::PrintJob.build(printer_name: printer.name, label_template_id: label_template.id, labels: {})
      expect(print_job).to_not be_valid
      expect(print_job.execute).to be_falsey
    end

    it "should be successful if it is a valid request" do
      allow(print_job.http).to receive(:post).with(print_job.printer_uri.path, print_job.request_body.to_s, print_job.headers).and_return(Net::HTTPResponse.new(2.0,200,"OK"))
      expect(print_job.execute).to be_truthy
    end

    it "should fail if the printing is unsuccessful" do
      allow(print_job.http).to receive(:post).and_return(Net::HTTPResponse.new(2.0,400,"Bad Request"))
      expect(print_job.execute).to be_falsey
    end

  end

end