class Section < ActiveRecord::Base

  has_many :bitmaps
  has_many :barcodes

  belongs_to :label_template

  accepts_nested_attributes_for :bitmaps, :barcodes

  def drawings
    Drawing.where(section: self)
  end

  def self.find_by_type(type)
    find_by(type: type.to_s.classify)
  end

  def self.permitted_attributes
    { "bitmaps_attributes" => Bitmap.permitted_attributes, "barcodes_attributes" => Barcode.permitted_attributes }
  end

end
