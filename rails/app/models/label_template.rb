class LabelTemplate < ActiveRecord::Base

  validates :name, presence: true, uniqueness: {case_sensitive: false}

  belongs_to :label_type

  validates :label_type, existence: true

  has_one :header
  has_one :footer
  has_one :label

  accepts_nested_attributes_for :header, :label, :footer


  def sections
    Section.where(label_template: self)
  end

  def self.permitted_attributes
    [ 
      "name",
      "label_type_id",
      "header_attributes" => Section.permitted_attributes, 
      "label_attributes" => Section.permitted_attributes, 
      "footer_attributes" => Section.permitted_attributes
    ]
  end

end
