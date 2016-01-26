class LabelTemplate < ActiveRecord::Base

  validates :name, presence: true, uniqueness: {case_sensitive: false}

  belongs_to :label_type

  validates :label_type, existence: true

  has_many :labels

  accepts_nested_attributes_for :labels

  def field_names
    label_fields.to_h
  end

  def dummy_labels
    label_fields.dummy_labels
  end

  def label_fields
    @label_fields ||= LabelFields.new do |lf|
      labels.each { |label| lf.add(label) }
    end
  end

  def self.permitted_attributes
    [ 
      "name",
      "label_type_id",
      "labels_attributes" => Label.permitted_attributes, 
    ]
  end

end
