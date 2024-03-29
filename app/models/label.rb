# frozen_string_literal: true

# Label
class Label < ApplicationRecord
  has_many :bitmaps, dependent: :destroy
  has_many :barcodes, dependent: :destroy

  belongs_to :label_template, optional: true

  validates :name, presence: true, format: { with: /\A[\w_]+\z/ }
  validates :name, uniqueness: { scope: :label_template_id },
                   if: proc { |l| l.label_template.present? || l.label_template_id.present? }
  validates_associated :bitmaps, :barcodes

  accepts_nested_attributes_for :bitmaps, :barcodes

  ##
  # Each label can have a list of drawings which is
  # all of the barcodes and bitmaps joined together.
  def drawings
    Drawing.where(label: self)
  end

  ##
  # The permitted attributes are made up of the name,
  # bitmap attributes and barcode attributes.
  def self.permitted_attributes
    ['name', { 'bitmaps_attributes' => Bitmap.permitted_attributes,
               'barcodes_attributes' => Barcode.permitted_attributes }]
  end

  ##
  # A list of the field names from each of the drawings
  def field_names
    drawings.pluck(:field_name)
  end

  ##
  # Labels can't be edited after creation so we need a
  # way to be able to modify existing labels
  # Create a dup of the label remove it's label template
  # if it has one and then dup each of the
  # drawings and add it to the new label
  # Saving the dup will create a whole new
  # label with new ids
  # TODO: shouldn't be overwriting dup, should use initialize_dup
  # but there doesn't seem to be a way to get the
  # object in the right state.
  def dup
    super.tap do |dupped|
      dupped.label_template = nil
      drawings.each do |drawing|
        drawing.barcode? ? dupped.barcodes << drawing.dup : dupped.bitmaps << drawing.dup
      end
      dupped.save
    end
  end
end
