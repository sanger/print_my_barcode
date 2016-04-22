# Example: 
# LabelType.create(name: "Plate", feed_value: "004", fine_adjustment: "08", pitch_length: "0110", print_width: "0920", print_length: "0080")
# Each label type will have different size and positioning.
# A label template must have a label type
class LabelType < ActiveRecord::Base

  validates :name, presence: true, uniqueness: {case_sensitive: false}

  validates :pitch_length, :print_width, :print_length, presence: true, format: {with: /\A\d{4}\z/}

  validates :feed_value, presence: true, format: {with: /\A\d{3}\z/}

  validates :fine_adjustment, presence: true, format: {with: /\A\d{2}\z/}

  ##
  # When a print job is execute the data input is made of labels and standard commands.
  # This includes things such as pitch length which are used for certain commands.
  # These need to be derived from the label type and fed into the print job.
  def template_attributes
    self.as_json.symbolize_keys
  end

  ##
  # Everything except the datetime stamps.
  def as_json(options = {})
    super( { except: [:created_at, :updated_at]}.merge(options) )
  end
end
