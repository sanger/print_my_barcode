class LabelType < ActiveRecord::Base

  validates :name, presence: true, uniqueness: {case_sensitive: false}

  validates :pitch_length, :print_width, :print_length, presence: true, format: {with: /\A\d{4}\z/}
end
