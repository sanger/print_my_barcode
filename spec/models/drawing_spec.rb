require 'rails_helper'

RSpec.describe Drawing, type: :model do
  it "should not be valid without an x_origin" do
    expect(build(:drawing, x_origin: nil)).to_not be_valid
  end

  it "x_origin should have four numbers" do
    expect(build(:drawing, x_origin: "111")).to_not be_valid
  end

  it "should not be valid without a y_origin" do
    expect(build(:drawing, y_origin: nil)).to_not be_valid
  end

  it "y_origin should have four numbers" do
    expect(build(:drawing, y_origin: "111")).to_not be_valid
  end

  it "should not be valid without a field_name" do
    expect(build(:drawing, field_name: nil)).to_not be_valid
  end

  it "field name should only be valid in a particular format" do
    expect(build(:drawing, field_name: "drawing_1")).to be_valid
    expect(build(:drawing, field_name: "drawing 1")).to_not be_valid
    expect(build(:drawing, field_name: "drawing-1")).to_not be_valid
    expect(build(:drawing, field_name: "drawing1*")).to_not be_valid
  end

  it "should assign a paceholder_id if there is a section" do
    expect(create(:drawing).placeholder_id).to be_nil
    
    label = create(:label)
    expect(create(:drawing, label: label).placeholder_id).to eq(1)
    expect(create(:drawing, label: label).placeholder_id).to eq(2)
  end

  it "should pad the placeholder_id" do
    expect(build(:drawing, placeholder_id: 1).padded_placeholder_id).to eq("0001")
  end

  it "template_attributes should contain the correct attributes" do
    drawing = create(:drawing)
    expect(drawing.template_attributes).to eq({id: drawing.padded_placeholder_id, x_origin: drawing.x_origin, y_origin: drawing.y_origin})
  end

  it "find_by_field_name should return correct drawing" do
    drawings = create_list(:drawing, 3)
    expect(Drawing.find_by_field_name(drawings.first.field_name)).to eq(drawings.first)
  end 

end
