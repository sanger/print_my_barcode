FactoryGirl.define do
  factory :user do
    sequence(:username) {|n| "User #{n}" }
    password "password"
    password_confirmation "password"
  end

end
