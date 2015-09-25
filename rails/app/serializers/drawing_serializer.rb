class DrawingSerializer < ActiveModel::Serializer
  
  attributes :x_origin, :y_origin, :field_name
end