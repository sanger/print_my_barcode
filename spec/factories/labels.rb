# frozen_string_literal: true

FactoryBot.define do
  factory :label do
    sequence(:name) { |n| "label_#{n}" }

    factory :label_with_drawings do
      after(:create) do |label|
        label.barcodes << FactoryBot.create_list(:barcode, 2)
        label.bitmaps << FactoryBot.create_list(:bitmap, 2)
      end
    end
  end
end
