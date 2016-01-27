class LabelTemplate < ActiveRecord::Base

  belongs_to :label_type
  has_many :labels

  validates :name, presence: true, uniqueness: {case_sensitive: false}
  validates :label_type, existence: true
  validates_associated :labels

  accepts_nested_attributes_for :labels

  ##
  # Returns all of the field names as a hash.
  def field_names
    label_fields.to_h
  end

  ##
  # Produces an object with all of the labels populated which can be used for testing e.g.
  # to produce an output file.
  def dummy_labels
    label_fields.dummy_labels
  end

  ##
  # A LabelFields object which will return all of the field names for the labels.
  # This includes nesting.
  def label_fields
    @label_fields ||= LabelFields.new do |lf|
      labels.each { |label| lf.add(label) }
    end
  end

  ##
  # For use as permitted attributes in the controller
  def self.permitted_attributes
    [ 
      "name",
      "label_type_id",
      "labels_attributes" => Label.permitted_attributes, 
    ]
  end

end
