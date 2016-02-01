require 'rails_helper'

RSpec.describe LabelType, type: :model do
  it "should not be valid without a name" do
    expect(build(:label_type, name: nil)).to_not be_valid
  end

  it "should not be valid without a unique name" do
    label_type = create(:label_type)
    expect(build(:label_type, name: label_type.name)).to_not be_valid
  end

  it "should not be valid without a pitch_length" do
    expect(build(:label_type, pitch_length: nil)).to_not be_valid
  end

  it "pitch_length should have four numbers" do
    expect(build(:label_type, pitch_length: "111")).to_not be_valid
  end

  it "should not be valid without a print_width" do
    expect(build(:label_type, print_width: nil)).to_not be_valid
  end

  it "print_width should have four numbers" do
    expect(build(:label_type, print_width: "11111")).to_not be_valid
  end

  it "should not be valid without a print_length" do
    expect(build(:label_type, print_length: nil)).to_not be_valid
  end

  it "print_length should have four numbers" do
    expect(build(:label_type, print_width: "ABCDE")).to_not be_valid
  end

  it "should not be valid without a feed_value" do
    expect(build(:label_type, feed_value: nil)).to_not be_valid
  end

  it "feed_value should have three numbers" do
    expect(build(:label_type, feed_value: "11")).to_not be_valid
    expect(build(:label_type, feed_value: "AA")).to_not be_valid
    expect(build(:label_type, feed_value: "1111")).to_not be_valid
  end

  it "should not be valid without a fine_adjustment" do
    expect(build(:label_type, fine_adjustment: nil)).to_not be_valid
  end

  it "fine_adjustment should have two numbers" do
    expect(build(:label_type, fine_adjustment: "111")).to_not be_valid
    expect(build(:label_type, fine_adjustment: "AAA")).to_not be_valid
    expect(build(:label_type, fine_adjustment: "1111")).to_not be_valid
  end

  it "#template_attributes should return the correct attributes" do
    label_type = create(:label_type)
    expect(label_type.template_attributes).to eq(
      {
        id: label_type.id,
        name: label_type.name,
        feed_value: label_type.feed_value,
        fine_adjustment: label_type.fine_adjustment,
        pitch_length: label_type.pitch_length, 
        print_width: label_type.print_width,
        print_length: label_type.print_length
      }
    )
  end
end
