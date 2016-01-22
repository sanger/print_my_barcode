class Drawing < ActiveRecord::Base

  include SubclassChecker

  before_create :add_placeholder_id

  belongs_to :label

  validates_presence_of :field_name

  validates :x_origin, :y_origin, presence: true, format: {with: /\A\d{4}\z/}

  has_subclasses :bitmap, :barcode

  def padded_placeholder_id
    pad_placeholder(4)
  end

  def find_by_field_name(field_name)
    find_by(field_name: field_name)
  end

  def options
    super || {}
  end

  def template_attributes
    options.merge(id: padded_placeholder_id, x_origin: x_origin, y_origin: y_origin)
  end

  def self.permitted_attributes
    (stored_attributes[:options] || []) + [:x_origin, :y_origin, :field_name]
  end

private
  
  def add_placeholder_id
    return unless label
    self.placeholder_id = label.drawings.count+1
  end

  def pad_placeholder(n)
    sprintf "%0#{n}d", placeholder_id.to_i
  end


end