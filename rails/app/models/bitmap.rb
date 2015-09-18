class Bitmap < Drawing
  store :options, accessors: [:horizontal_magnification, :vertical_magnification, :font, :space_adjustment, :rotational_angles]

  validates_format_of :horizontal_magnification, :vertical_magnification, with: /\A\d{1}\z/, allow_blank: true

  validates_format_of :space_adjustment, :rotational_angles, with: /\A\d{2}\z/, allow_blank: true

  validates_format_of :font, with: /\A[A-W]{1}\z/, allow_blank: true

  def padded_placeholder_id
    pad_placeholder(3)
  end

private
  
  def add_placeholder_id
    return unless section
    self.placeholder_id = section.bitmaps.count+1
  end
end