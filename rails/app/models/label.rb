class Label < ActiveRecord::Base

  has_many :bitmaps
  has_many :barcodes

  belongs_to :label_template

  validates :name, presence: true, uniqueness: true
  validates_format_of :name, with: /\A[\w\_]+\z/
  
  accepts_nested_attributes_for :bitmaps, :barcodes

  def drawings
    Drawing.where(label: self)
  end

  def self.permitted_attributes
    ["name", { "bitmaps_attributes" => Bitmap.permitted_attributes, "barcodes_attributes" => Barcode.permitted_attributes }]
  end

  def field_names
    drawings.pluck(:field_name)
  end
  
end