require 'rails_helper'

RSpec.describe Section, type: :model do

  it "can have many drawings" do
    bitmaps = create_list(:bitmap, 3)
    section = create(:section, bitmaps: bitmaps)
    expect(section.drawings.count).to eq(3)
  end

  it "can have many barcodes" do
    barcodes = create_list(:barcode, 3)
    section = create(:section, barcodes: barcodes)
    expect(section.barcodes.count).to eq(3)
  end

  it "can have many bitmaps" do
    bitmaps = create_list(:bitmap, 3)
    section = create(:section, bitmaps: bitmaps)
    expect(section.bitmaps.count).to eq(3)
  end

  it "#find_by_type should find a section by its type" do
    header = create(:header)
    footer = create(:footer)
    expect(Section.find_by_type(:header)).to eq(header)
  end

end
