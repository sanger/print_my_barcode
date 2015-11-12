require 'rails_helper'

RSpec.describe User, type: :model do
  it "should not be valid without a login" do
    expect(build(:user, login: nil)).to_not be_valid
  end

  it "should not be valid without a unique login" do
    user = create(:user)
    expect(build(:user, login: user.login)).to_not be_valid
  end

  it "should authenticate the user" do
    user_1 = create(:user)
    user_2 = build(:user)
    allow(Ldap).to receive(:authenticate).with(user_1.login, "password").and_return(true)
    expect(User.authenticate(user_1.login, "password")).to be_truthy
    expect(User.authenticate(user_2.login, "password")).to be_falsey

    allow(Ldap).to receive(:authenticate).with(user_1.login, "password").and_return(false)
    expect(User.authenticate(user_1.login, "password")).to be_falsey
    expect(User.authenticate(user_2.login, "password")).to be_falsey
  end
end
