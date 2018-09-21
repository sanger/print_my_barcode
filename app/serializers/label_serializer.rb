# frozen_string_literal: true

# LabelSerializer
class LabelSerializer < ActiveModel::Serializer
  attributes :name

  has_many :bitmaps
  has_many :barcodes
end
