FactoryGirl.define do
  factory :template_builder, class: TemplateBuilder do

    label_template { create(:label_template) }
    values { label_template.field_names.dummy_values }
  
    initialize_with   { new(label_template, values) }

  end

end