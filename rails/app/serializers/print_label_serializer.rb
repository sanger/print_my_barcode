class PrintLabelSerializer < ActiveModel::Serializer

  attributes :printer_name, :label_template_id, :values
  
end