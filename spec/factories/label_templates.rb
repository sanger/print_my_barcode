# frozen_string_literal: true

FactoryBot.define do
  factory :label_template do
    sequence(:name) { |n| "Label Template #{n}" }
    label_type
    labels do
      [FactoryBot.create(:label_with_drawings, name: 'header'),
       FactoryBot.create_list(:label_with_drawings, 5),
       FactoryBot.create(:label_with_drawings, name: 'footer')].flatten
    end
  end

  factory :label_template_simple, class: LabelTemplate do
    sequence(:name) { |n| "label_template_#{n}" }
    label_type
    labels do
      [FactoryBot.create(:label_with_drawings)]
    end
  end
end
