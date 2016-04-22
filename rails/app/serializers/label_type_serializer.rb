
class LabelTypeSerializer < ActiveModel::Serializer

  attributes :id, :feed_value, :fine_adjustment, :pitch_length, :print_width, :print_length, :name
end
