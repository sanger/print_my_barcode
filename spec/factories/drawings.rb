FactoryGirl.define do
  factory :drawing do
    x_origin "0030"
    y_origin "0035"
    field_name "a_simple_field"

    factory :barcode, class: "Barcode" do
      barcode_type "7"
      one_module_width "09"
      height "0170"
      rotational_angle "1"
      one_cell_width "03"
      type_of_check_digit "2"
      bar_height "0001"
      no_of_columns "01"
      sequence(:field_name) {|n| "barcode_#{n}" }
    end

    factory :bitmap, class: "Bitmap" do
      horizontal_magnification "2"
      vertical_magnification "4"
      font "A" 
      space_adjustment "12"
      rotational_angles "14"
      sequence(:field_name) {|n| "bitmap_#{n}" }
    end
    
  end

end
