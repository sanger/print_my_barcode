require 'rails_helper'

RSpec.describe Barcode, type: :model do

  it "should validate form of barcode type" do
    expect(build(:barcode, barcode_type: "1")).to be_valid
    expect(build(:barcode, barcode_type: "10")).to_not be_valid
    expect(build(:barcode, barcode_type: "X")).to be_valid
    expect(build(:barcode, barcode_type: "XX")).to_not be_valid
  end

  it "should validate format of one_module_width" do
    expect(build(:barcode, one_module_width: "XX")).to_not be_valid
  end

  it "should validate format of height" do
    expect(build(:barcode, height: "111")).to_not be_valid
    expect(build(:barcode, height: "111X")).to_not be_valid
  end

  it "should validate format of rotational angles" do
    expect(build(:barcode, rotational_angle: "111")).to_not be_valid
    expect(build(:barcode, rotational_angle: "XXX")).to_not be_valid
  end

  it "should validate format of one cell width" do
    expect(build(:barcode, one_module_width: "XX")).to_not be_valid
  end

  it "should assign a placeholder id if there is a section" do
    label = create(:label)

    create_list(:bitmap, 2, label: label)
    expect(create(:barcode, label: label).placeholder_id).to eq(1)
    expect(create(:barcode, label: label).placeholder_id).to eq(2)
  end

  it "should pad the placeholder_id" do
    expect(build(:barcode, placeholder_id: 1).padded_placeholder_id).to eq("01")
  end

  it "template_attributes should contain the correct attributes" do
    barcode = create(:barcode)
    expect(barcode.template_attributes).to eq(barcode.options.merge(id: barcode.padded_placeholder_id, x_origin: barcode.x_origin, y_origin: barcode.y_origin))
  end

end
