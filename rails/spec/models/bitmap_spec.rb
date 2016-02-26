require 'rails_helper'

RSpec.describe Bitmap, type: :model do
  it "validate format of horizontal_magnification" do
    expect(build(:bitmap, horizontal_magnification: "111")).to_not be_valid
    expect(build(:bitmap, horizontal_magnification: "X")).to_not be_valid
  end

  it "should validate format of vertical_magnification" do
    expect(build(:bitmap, vertical_magnification: "111")).to_not be_valid
    expect(build(:bitmap, vertical_magnification: "X")).to_not be_valid
  end

  it "should validate format of font" do
    expect(build(:bitmap, font: "1")).to_not be_valid
    expect(build(:bitmap, font: "Z")).to_not be_valid
  end

  it "should validate format of space_adjustment" do
    expect(build(:bitmap, space_adjustment: "111")).to_not be_valid
    expect(build(:bitmap, space_adjustment: "XXX")).to_not be_valid
  end

  it "should validate format of rotational_angles" do
    expect(build(:bitmap, rotational_angles: "111")).to_not be_valid
    expect(build(:bitmap, rotational_angles: "XXX")).to_not be_valid
  end

  it "should assign a placeholder id if there is a a section" do
    label = create(:label)

    create_list(:barcode, 2, label: label)
    expect(create(:bitmap, label: label).placeholder_id).to eq(1)
    expect(create(:bitmap, label: label).placeholder_id).to eq(2)
  end

  it "should pad the placeholder_id" do
    expect(build(:bitmap, placeholder_id: 1).padded_placeholder_id).to eq("001")
  end

  it "template_attributes should containt the correct attributes" do
    bitmap = create(:bitmap)
    expect(bitmap.template_attributes).to eq(bitmap.options.merge(id: bitmap.padded_placeholder_id, x_origin: bitmap.x_origin, y_origin: bitmap.y_origin))
  end
end
