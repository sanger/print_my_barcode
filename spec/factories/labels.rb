FactoryGirl.define do
  factory :label do

    sequence(:name) {|n| "label_#{n}" }

    factory :label_with_drawings do

      after(:create) do |label|
        label.barcodes << FactoryGirl.create_list(:barcode, 2)
        label.bitmaps << FactoryGirl.create_list(:bitmap, 2)
      end
    end

  end

end
