class LabelTemplate < ActiveRecord::Base

  belongs_to :label_type
  has_many :labels, dependent: :destroy

  validates :name, presence: true, uniqueness: {case_sensitive: false}
  validates :label_type, existence: true
  validates_associated :labels

  accepts_nested_attributes_for :labels

  delegate :dummy_labels, to: :label_fields

  ##
  # Returns all of the field names as a hash.
  def field_names
    label_fields.to_h
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

  ##
  # An implementation of dup which allows the name to be changed.
  # Dup the original template. If a name is not passed the name will be changed
  # to "label_template_name copy"
  # dup each of the labels and add it to the new label template
  # Saving the dup will create a whole new record with new ids.
  def super_dup(new_name = nil)
    duped = self.dup
    duped.name = new_name || "#{name} copy"
    labels.each do |label|
      duped.labels << label.dup
    end
    duped.save
    duped
  end

end
