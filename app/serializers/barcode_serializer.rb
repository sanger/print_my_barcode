# frozen_string_literal: true

# BarcodeSerializer
class BarcodeSerializer < ActiveModel::Serializer
  attributes(*Barcode.permitted_attributes)
end
