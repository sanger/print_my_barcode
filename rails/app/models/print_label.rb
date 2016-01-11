class PrintLabel

  include ActiveModel::Model 

  attr_accessor :printer_name, :label_template_id, :values
  attr_reader :printer, :label_template

  validates_presence_of :printer_name, :label_template_id, :values
  validate :check_printer, :check_label_template, :check_values

  def initialize(attributes = {})
    super
    @printer = Printer.find_by_name(printer_name)
    @label_template = LabelTemplate.find_by_id(label_template_id)
  end

private

  def check_printer
    errors.add(:base, "Printer does not exist") unless printer
  end

  def check_label_template
    errors.add(:base, "Label template does not exist") unless label_template
  end

  def check_values
    if label_template && values
      unless values[:label].keys == label_template.field_names.label
        errors.add(:base, "The label does not contain the required fields")
      end
    end
  end
  
end