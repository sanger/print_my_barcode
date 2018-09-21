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
end
