# frozen_string_literal: true

# Example:
#  Barcode.create(field_name: "barcode", x_origin: "0300",
#  y_origin: "0000", barcode_type: "9",
#  one_module_width: "02", height: "0070")
class Barcode < Drawing
  store :options, accessors: %i[barcode_type one_module_width
                                height rotational_angle one_cell_width
                                type_of_check_digit no_of_columns bar_height
                                narrow_bar_width narrow_space_width
                                wide_bar_width wide_space_width
                                char_to_char_space_width]

  validates :barcode_type, format: { with: /\A[0-9A-Z]{1}\z/, allow_blank: true }

  validates :one_module_width, :one_cell_width, :no_of_columns,
            :narrow_bar_width, :narrow_space_width,
            :wide_bar_width, :wide_space_width,
            :char_to_char_space_width,
            format: { with: /\A\d{2}\z/, allow_blank: true }

  validates :rotational_angle, :type_of_check_digit,
            format: { with: /\A\d{1}\z/, allow_blank: true }

  validates :height, :bar_height, format: { with: /\A\d{4}\z/,
                                            allow_blank: true }

  ##
  # e.g. 01
  def padded_placeholder_id
    pad_placeholder(2)
  end

  private

  def add_placeholder_id
    return if label.blank?

    self.placeholder_id = label.barcodes.count + 1
  end
end
