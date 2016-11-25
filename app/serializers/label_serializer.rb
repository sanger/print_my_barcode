class LabelSerializer < ActiveModel::Serializer

  attributes :name

  has_many :bitmaps
  has_many :barcodes
  
end