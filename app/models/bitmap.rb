# Example:
#  Bitmap.create(field_name: "header_text1", x_origin: "0020"
#  ,y_origin: "0035", horizontal_magnification: "1", 
#  vertical_magnification: "1", font: "G", space_adjustment: "00", 
# rotational_angles: "00")
class Bitmap < Drawing
  store :options, accessors: [:horizontal_magnification, 
                              :vertical_magnification,
                              :font, :space_adjustment, :rotational_angles]

  validates_format_of :horizontal_magnification, 
                      :vertical_magnification,
                      with: /\A\d{1,2}\z/, allow_blank: true

  validates_format_of :space_adjustment, :rotational_angles,
                      with: /\A\d{2}\z/, allow_blank: true

  validates_format_of :font, with: /\A[A-W]{1}\z/, allow_blank: true

  ##
  # e.g. 001
  def padded_placeholder_id
    pad_placeholder(3)
  end

  private
  
  def add_placeholder_id
    return unless label.present?
    self.placeholder_id = label.bitmaps.count + 1
  end
end
