require 'rails_helper'

RSpec.describe LabelTemplate, type: :model do
  it "should not be valid without a label_type" do
    expect(build(:label_template, label_type: nil)).to_not be_valid
  end

  it "should have a header, footer and label" do
    label_template = build(:label_template)
    expect(label_template.header).to_not be_nil
    expect(label_template.footer).to_not be_nil
    expect(label_template.label).to_not be_nil
    expect(label_template.sections.count).to eq(3)
  end
end
