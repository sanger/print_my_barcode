class PrintJobSerializer < ActiveModel::Serializer

  attributes :printer_name, :label_template_id, :labels
  
end