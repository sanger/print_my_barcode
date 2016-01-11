require "rails_helper"

RSpec.describe LabelFields, type: :model do |variable|

  attr_reader :label_fields
  
  let(:field_names) { { header: ["header_text_1", "header_text_2"], label: ["label_text_1", "label_text_2"], footer: ["footer_text_1", "footer_text_2"] } }

  before(:each) do
    @label_fields = LabelFields.new do |lf|
      field_names.each do |k,v|
        lf.add(k,v)
      end
    end
  end

  it "should create header variables" do
    expect(label_fields.header).to eq(["header_text_1", "header_text_2"])
  end

  it "should create label variables" do
    expect(label_fields.label).to eq(["label_text_1", "label_text_2"])
  end

  it "should create footer variables" do
    expect(label_fields.footer).to eq(["footer_text_1", "footer_text_2"])
  end

  it "should be able to create some dummy values" do
    expect(label_fields.dummy_values).to eq({ header: {header_text_1: "header_text_1", header_text_2: "header_text_2"}, label: {label_text_1: "label_text_1", label_text_2: "label_text_2"}, footer: {footer_text_1: "footer_text_1", footer_text_2: "footer_text_2"} }.with_indifferent_access)
  end

end