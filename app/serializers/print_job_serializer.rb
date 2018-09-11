# frozen_string_literal: true

# PrintJobSerializer
class PrintJobSerializer < ActiveModel::Serializer
  attributes :printer_name, :label_template_id, :labels

  type 'print_jobs'
end
