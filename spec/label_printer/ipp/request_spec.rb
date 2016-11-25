require "rails_helper"

RSpec.describe LabelPrinter::IPP::Request, type: :model do

  let(:data_input)  { build(:data_input) }
  let(:ipp_request) { LabelPrinter::IPP::Request.new("http://forest:631/pinetree", data_input) }

  it "should have a version number" do
    expect(ipp_request.version_number).to eq(1.1)
    ipp_request.version_number = 2.2
    expect(ipp_request.version_number).to eq(2.2)
  end

  it "should have a request id" do
    expect(ipp_request.request_id).to eq(1)
    ipp_request.request_id = 290
    expect(ipp_request.request_id).to eq(290)
  end

  it "should have a printer uri" do
    expect(ipp_request.printer_uri).to eq("http://forest:631/pinetree")
  end

  it "should have a set of attributes" do
    expect(ipp_request.attribute_tags.to_s).to eq("0x01#{LabelPrinter::IPP::CharsetType.new.to_s}#{LabelPrinter::IPP::NaturalLanguageType.new.to_s}#{LabelPrinter::IPP::UriType.new("http://forest:631/pinetree").to_s}0x03")
  end

  it "should have a header" do
    expect(ipp_request.header.to_s).to eq("0x01010x0020x00000001")
  end

  it "should have some data input" do
    expect(ipp_request.data_input).to eq(data_input)
  end

  it "should have a data length" do
    expect(ipp_request.data_length).to eq((ipp_request.header.length+ipp_request.attribute_tags.length+data_input.length).to_s)
  end
  
end