FactoryGirl.define do
  factory :label_type do
    pitch_length "0100"
    print_width "0350"
    print_length "0450"
    sequence(:name) {|n| "Label Type #{n}" }
  end

end
