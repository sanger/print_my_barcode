class Section < ActiveRecord::Base

  has_many :drawings

  belongs_to :label_template

  def barcodes
    drawings.where(type: "Barcode")
  end

  def bitmaps
    drawings.where(type: "Bitmap")
  end

  def self.find_by_type(type)
    find_by(type: type.to_s.classify)
  end

end
