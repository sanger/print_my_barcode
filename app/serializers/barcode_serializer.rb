class BarcodeSerializer < ActiveModel::Serializer
  
  attributes(*Barcode.permitted_attributes)
end