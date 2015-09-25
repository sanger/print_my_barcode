class LabelTemplateSerializer < ActiveModel::Serializer
  attributes :id

  has_one :label_type
  has_one :header
  has_one :label
  has_one :footer
end
