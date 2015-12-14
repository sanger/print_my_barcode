# Example:
#  Barcode.create(field_name: "barcode", x_origin: "0300", y_origin: "0000", barcode_type: "9",
#  one_module_width: "02", height: "0070")
class Barcode < Drawing
  store :options, accessors: [:barcode_type, :one_module_width, :height]

  validates_format_of :barcode_type, with: /\A[0-9]{1}\z/, allow_blank: true

  validates_format_of :one_module_width, with: /\A\d{2}\z/, allow_blank: true

  validates_format_of :height, with: /\A\d{4}\z/, allow_blank: true

  def padded_placeholder_id
    pad_placeholder(2)
  end

private
  
  def add_placeholder_id
    return unless section
    self.placeholder_id = section.barcodes.count+1
  end
end