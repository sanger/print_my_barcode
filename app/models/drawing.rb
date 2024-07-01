# frozen_string_literal: true

##
# A drawing is something which can be output to a printer,
# either a barcode or a bitmap (some text)
# Each drawing will have a placeholder id which is unique with
# respect to its label.
# Each drawing must have a field name, x origin and y origin
class Drawing < ApplicationRecord
  before_create :add_placeholder_id

  belongs_to :label, optional: true

  validates :field_name, presence: true, format: { with: /\A[\w_]+\z/ }
  validates :x_origin, :y_origin, presence: true, format: { with: /\A\d{4}\z/ }

  ##
  # e.g. 0001
  def padded_placeholder_id
    pad_placeholder(4)
  end

  ##
  # Find a drawing by its field name
  def find_by_field_name(field_name)
    find_by(field_name: field_name)
  end

  ##
  # options is a hash of the optional attributes for a drawing.
  # This is a store field so can change.
  def options
    super || {}
  end

  ##
  # Used to create commands when building a print job.
  # All of the options along with the placeholder_id and x and y origins.
  def template_attributes
    options.merge(id: padded_placeholder_id, x_origin: x_origin, y_origin: y_origin)
  end

  ##
  # A list of all of the stored attributes along with required fields
  def self.permitted_attributes
    (stored_attributes[:options] || []) + %i[x_origin y_origin field_name]
  end

  def barcode?
    instance_of?(Barcode)
  end

  def bitmap?
    instance_of?(Bitmap)
  end

  private

  def add_placeholder_id
    return unless label

    self.placeholder_id = label.drawings.count + 1
  end

  def pad_placeholder(num)
    format "%0#{num}d", placeholder_id.to_i
  end
end
