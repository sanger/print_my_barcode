FactoryGirl.define do
  factory :user do
    sequence(:login) {|n| "Login #{n}" }
  end

end
