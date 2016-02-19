class Label < ActiveRecord::Base

  has_many :bitmaps, dependent: :destroy
  has_many :barcodes, dependent: :destroy

  belongs_to :label_template

  validates :name, presence: true, uniqueness: { scope: :label_template_id }, format: { with: /\A[\w\_]+\z/ }
  validates_associated :bitmaps, :barcodes
  
  accepts_nested_attributes_for :bitmaps, :barcodes

  ##
  # Each label can have a list of drawings which is all of the barcodes and bitmaps joined together.
  def drawings
    Drawing.where(label: self)
  end

  ##
  # The permitted attributes are made up of the name, bitmap attributes and barcode attributes.
  def self.permitted_attributes
    ["name", { "bitmaps_attributes" => Bitmap.permitted_attributes, "barcodes_attributes" => Barcode.permitted_attributes }]
  end

  ## 
  # A list of the field names from each of the drawings
  def field_names
    drawings.pluck(:field_name)
  end
  
end