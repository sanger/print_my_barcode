FactoryGirl.define do
  factory :data_input, class: LabelPrinter::DataInput::Base do

    label_template { create(:label_template) }
    values { label_template.field_names.dummy_values }
  
    initialize_with   { new(label_template, values) }

  end

end