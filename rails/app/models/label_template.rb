class LabelTemplate < ActiveRecord::Base

  belongs_to :label_type

  validates :label_type, existence: true

  has_one :header
  has_one :footer
  has_one :label

  def sections
    Section.where(label_template: self)
  end

end
