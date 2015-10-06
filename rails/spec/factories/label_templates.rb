FactoryGirl.define do
  factory :label_template do
    sequence(:name) {|n| "Label Template #{n}" }
    label_type
    header { FactoryGirl.create(:header_with_drawings) }
    footer { FactoryGirl.create(:footer_with_drawings) }
    label { FactoryGirl.create(:label_with_drawings) }
  end

end
