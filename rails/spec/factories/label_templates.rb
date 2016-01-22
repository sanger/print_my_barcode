FactoryGirl.define do
  factory :label_template do
    sequence(:name) {|n| "Label Template #{n}" }
    label_type
    labels { 
      [ FactoryGirl.create(:label_with_drawings, name: "header"),
        FactoryGirl.create_list(:label_with_drawings, 5),
        FactoryGirl.create(:label_with_drawings, name: "footer")
      ].flatten 
    }
  end

end
