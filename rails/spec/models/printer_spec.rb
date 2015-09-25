require 'rails_helper'

RSpec.describe Printer, type: :model do
  it "should not be valid without a name" do
    expect(build(:printer, name: nil)).to_not be_valid
  end

  it "should not be valid without a unique name" do
    printer = create(:printer)
    expect(build(:printer, name: printer.name)).to_not be_valid
  end
end
