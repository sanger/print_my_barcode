# frozen_string_literal: true

# Example:
#  Bitmap.create(field_name: "header_text1", x_origin: "0020"
#  ,y_origin: "0035", horizontal_magnification: "1",
#  vertical_magnification: "1", font: "G", space_adjustment: "00",
# rotational_angles: "00")
class Bitmap < Drawing
  store :options, accessors: %i[horizontal_magnification
                                vertical_magnification
                                font space_adjustment rotational_angles]

  validates :horizontal_magnification,
            :vertical_magnification,
            format: { with: /\A\d{1,2}\z/, allow_blank: true }

  validates :space_adjustment, :rotational_angles,
            format: { with: /\A\d{2}\z/, allow_blank: true }

  validates :font, format: { with: /\A[A-W]{1}\z/, allow_blank: true }

  ##
  # e.g. 001
  def padded_placeholder_id
    pad_placeholder(3)
  end

  private

  def add_placeholder_id
    return if label.blank?

    self.placeholder_id = label.bitmaps.count + 1
  end
end
