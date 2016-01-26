FactoryGirl.define do
  factory :data_input, class: LabelPrinter::DataInput::Base do

    label_template { create(:label_template) }
    input_values { label_template.dummy_labels.to_h }
  
    initialize_with   { new(label_template, input_values) }

  end

end