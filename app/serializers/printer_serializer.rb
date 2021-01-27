# frozen_string_literal: true

# PrinterSerializer
class PrinterSerializer < ActiveModel::Serializer
  attributes :id, :name, :protocol, :printer_type
end
