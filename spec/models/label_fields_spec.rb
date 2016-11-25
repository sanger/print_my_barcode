require "rails_helper"

RSpec.describe LabelFields, type: :model do 

  attr_reader :label_fields, :labels

  let(:labels) {  [create(:label, name: "header", bitmaps: [create(:bitmap, field_name: "header_text_1"), create(:bitmap, field_name: "header_text_2")]),
                    create(:label, name: "label1", bitmaps: [create(:bitmap, field_name: "label_text_1"), create(:bitmap, field_name: "label_text_2")]),
                    create(:label, name: "label2", bitmaps: [create(:bitmap, field_name: "label_text_3"), create(:bitmap, field_name: "label_text_4")]),
                    create(:label, name: "footer", bitmaps: [create(:bitmap, field_name: "footer_text_1"), create(:bitmap, field_name: "footer_text_2")])
                    ]
                  }
 
  before(:each) do
    @label_fields = LabelFields.new do |lf|
      labels.each { |label| lf.add(label) }
    end
  end

  it "should create header variables" do
    expect(label_fields.find(:header)).to eq(["header_text_1", "header_text_2"])
  end

  it "should create labels variables" do
    expect(label_fields.find(:label1)).to eq(["label_text_1", "label_text_2"])
    expect(label_fields.find(:label2)).to eq(["label_text_3", "label_text_4"])
  end

  it "should create footer variables" do
    expect(label_fields.find(:footer)).to eq(["footer_text_1", "footer_text_2"])
  end

  it "should be able to create some dummy labels" do
    expect(label_fields.dummy_labels.find(:header)).to eq({header_text_1: "header_text_1", header_text_2: "header_text_2"}.with_indifferent_access)
    expect(label_fields.dummy_labels.find(:label2)).to eq({label_text_3: "label_text_3", label_text_4: "label_text_4"}.with_indifferent_access)
    expect(label_fields.dummy_labels.to_h).to eq({ 
      header: {header_text_1: "header_text_1", header_text_2: "header_text_2"}, 
      body: [
                { label1: {label_text_1: "label_text_1", label_text_2: "label_text_2"},
                  label2: {label_text_3: "label_text_3", label_text_4: "label_text_4"} },
                { label1: {label_text_1: "label_text_1", label_text_2: "label_text_2"},
                  label2: {label_text_3: "label_text_3", label_text_4: "label_text_4"} }
              ], 
      footer: {footer_text_1: "footer_text_1", footer_text_2: "footer_text_2"}
      }.with_indifferent_access)
  end

  it "should provide an actual count which is based on the actual number of dummy values" do
    expect(label_fields.dummy_labels.actual_count).to eq(6)
  end

end