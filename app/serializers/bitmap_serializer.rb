class BitmapSerializer < ActiveModel::Serializer
  
  attributes(*Bitmap.permitted_attributes)
end