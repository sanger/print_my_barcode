class SectionSerializer < ActiveModel::Serializer

  has_many :bitmaps
  has_many :barcodes
  
end