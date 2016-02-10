require 'rails_helper'

RSpec.describe Label, type: :model do

  it "can have many drawings" do
    bitmaps = create_list(:bitmap, 3)
    label = create(:label, bitmaps: bitmaps)
    expect(label.drawings.count).to eq(3)
  end

  it "can have many barcodes" do
    barcodes = create_list(:barcode, 3)
    label = create(:label, barcodes: barcodes)
    expect(label.barcodes.count).to eq(3)
  end

  it "can have many bitmaps" do
    bitmaps = create_list(:bitmap, 3)
    label = create(:label, bitmaps: bitmaps)
    expect(label.bitmaps.count).to eq(3)
  end

  it "#field_names should return a list of field names" do
    barcodes = create_list(:barcode, 3)
    label = create(:label, barcodes: barcodes)
    expect(label.field_names).to eq( barcodes.map { |barcode| barcode.field_name} )
  end

  it "label should not be valid without a name" do
    expect(build(:label, name: nil)).to_not be_valid
  end

  it "label should be unique for a particular label template" do
    label_template_1 = create(:label_template)
    label_template_2 = create(:label_template)
    label = create(:label, label_template: label_template_1)
    expect(build(:label, label_template: label_template_1, name: label.name)).to_not be_valid
    expect(build(:label, label_template: label_template_2, name: label.name)).to be_valid
  end

  it "name should only be valid in a particular format" do
    expect(build(:label, name: "label_1")).to be_valid
    expect(build(:label, name: "label 1")).to_not be_valid
    expect(build(:label, name: "label-1")).to_not be_valid
    expect(build(:label, name: "label1*")).to_not be_valid
  end

end
