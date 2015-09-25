FactoryGirl.define do
  factory :printer do
    sequence(:name) {|n| "Printer #{n}" }
  end

end
