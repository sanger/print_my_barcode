# frozen_string_literal: true

# LabelTemplateSerializer
class LabelTemplateSerializer < ActiveModel::Serializer
  attributes :id, :name

  has_one :label_type

  has_many :labels
end
