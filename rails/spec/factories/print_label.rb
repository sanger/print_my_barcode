FactoryGirl.define do
  factory :print_label do

    transient do
      label_template { create(:label_template) }
    end

    printer_name { create(:printer).name }
    label_template_id { label_template.id }
    values { label_template.field_names.dummy_values }


    initialize_with { new(printer_name: printer_name, label_template_id: label_template_id, values: values) }
  end

end