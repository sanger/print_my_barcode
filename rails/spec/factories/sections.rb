FactoryGirl.define do
  factory :section do

    trait :drawings do
      after(:create) do |section|
        section.drawings << FactoryGirl.create_list(:barcode, 2)
        section.drawings << FactoryGirl.create_list(:bitmap, 2)
      end
    end

    factory :section_with_drawings, traits: [:drawings]

    factory :header, class: "Header" do
      factory :header_with_drawings, traits: [:drawings]
    end

    factory :footer, class: "Footer" do
      factory :footer_with_drawings, traits: [:drawings]
    end

    factory :label, class: "Label" do
      factory :label_with_drawings, traits: [:drawings]
    end

  end

end
