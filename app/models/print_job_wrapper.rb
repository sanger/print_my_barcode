# frozen_string_literal: true

# PrintJobWrapper
class PrintJobWrapper
  include ActiveModel::Model

  attr_reader :printer_name, :label_template_name

  validate :check_attributes

  def initialize(params = {})
    @printer_name = params['printer_name']
    @label_template_name = params['label_template_name']
  end

  def check_attributes
    errors.add(:printer_name, 'does not exist') if printer_name.nil?
    errors.add(:label_template_name, 'does not exist') if label_template_name.nil?
  end
end
