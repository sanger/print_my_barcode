FactoryGirl.define do
  factory :template_builder, class: TemplateBuilder do
    transient do
      header            { create(:header_with_drawings) }
      header_values     { header.drawings.pluck(:field_name).to_h_derived }
      label             { create(:label_with_drawings) }
      label_values      { label.drawings.pluck(:field_name).to_h_derived }
      footer            { create(:footer_with_drawings) }
      footer_values     { footer.drawings.pluck(:field_name).to_h_derived }
      label_template    { create(:label_template, header: header, label: label, footer: footer) }
      values            { {header: header_values, label: label_values, footer: footer_values} }
    end
  
    initialize_with   { new(label_template, values) }

  end

end