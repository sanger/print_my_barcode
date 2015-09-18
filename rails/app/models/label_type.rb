class LabelType < ActiveRecord::Base

  validates :name, presence: true, uniqueness: {case_sensitive: false}

  validates :pitch_length, :print_width, :print_length, presence: true, format: {with: /\A\d{4}\z/}

  validates :feed_value, presence: true, format: {with: /\A\d{2}\z/}

  validates :fine_adjustment, presence: true, format: {with: /\A\d{3}\z/}

  def template_attributes
    {
      feed_value: feed_value, 
      fine_adjustment: fine_adjustment,
      pitch_length: pitch_length, 
      print_width: print_width,
      print_length: print_length
    }
  end
end
