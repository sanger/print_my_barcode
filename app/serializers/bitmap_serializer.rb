# frozen_string_literal: true

# BitmapSerializer
class BitmapSerializer < ActiveModel::Serializer
  attributes(*Bitmap.permitted_attributes)
end
