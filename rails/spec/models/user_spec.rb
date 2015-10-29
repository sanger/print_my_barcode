require 'rails_helper'

RSpec.describe User, type: :model do
  it "should not be valid without a username" do
    expect(build(:user, username: nil)).to_not be_valid
  end

  it "should not be valid without a password" do
    expect(build(:user, password: nil)).to_not be_valid
    expect(build(:user, password_confirmation: "crap")).to_not be_valid
  end

  it "should not be valid without a unique username" do
    user = create(:user)
    expect(build(:user, username: user.username)).to_not be_valid
  end
end
