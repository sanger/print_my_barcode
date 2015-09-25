class LabelType < ActiveRecord::Base

  validates :name, presence: true, uniqueness: {case_sensitive: false}

  validates :pitch_length, :print_width, :print_length, presence: true, format: {with: /\A\d{4}\z/}

  validates :feed_value, presence: true, format: {with: /\A\d{2}\z/}

  validates :fine_adjustment, presence: true, format: {with: /\A\d{3}\z/}

  def template_attributes
    self.as_json.symbolize_keys
  end

  def as_json(options = {})
    super( { except: [:created_at, :updated_at]}.merge(options) )
  end
end
