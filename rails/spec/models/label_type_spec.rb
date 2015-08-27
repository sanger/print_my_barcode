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
end
