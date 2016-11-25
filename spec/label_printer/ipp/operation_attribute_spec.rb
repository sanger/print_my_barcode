require "rails_helper"

RSpec.describe LabelPrinter::IPP::OperationAttribute, type: :model do

  describe "Basic operation attribute" do
    let(:operation_attribute) { LabelPrinter::IPP::OperationAttribute.new("0x99", "nose-job", "roman-crooked")}

    it "should have a value_tag" do
      expect(operation_attribute.value_tag).to eq("0x99")
    end

    it "should have a name_length" do
      expect(operation_attribute.name_length).to eq("0x0008")
    end

    it "should have a name" do
      expect(operation_attribute.name).to eq("nose-job")
    end

    it "should have a value_length" do
      expect(operation_attribute.value_length).to eq("0x000D")
    end

    it "should have a value" do
      expect(operation_attribute.value).to eq("roman-crooked")
    end

    it "#to_s should return a wonderful string of all the attributes" do
      expect(operation_attribute.to_s).to eq("0x990x0008nose-job0x000Droman-crooked")
    end
  end

  describe "Standard operation attributes" do

    it "charset type should return the correct attributes" do
      charset_type = LabelPrinter::IPP::CharsetType.new
      expect(charset_type.value_tag).to eq("0x47")
      expect(charset_type.name).to eq("attributes-charset")
      expect(charset_type.value).to eq("us-ascii")
    end

    it "natural langauge type should return the correct attributes" do
      natural_language_type = LabelPrinter::IPP::NaturalLanguageType.new
      expect(natural_language_type.value_tag).to eq("0x48")
      expect(natural_language_type.name).to eq("attributes-natural-language")
      expect(natural_language_type.value).to eq("en-US")
    end

    it "uri type should return the correct attributes" do
      uri_type = LabelPrinter::IPP::UriType.new("http://forest:631/pinetree")
      expect(uri_type.value_tag).to eq("0x000B")
      expect(uri_type.name).to eq("printer-uri")
      expect(uri_type.value).to eq("http://forest:631/pinetree")
    end
  end

end