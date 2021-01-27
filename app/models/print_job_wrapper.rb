# frozen_string_literal: true

# PrintJobWrapper
class PrintJobWrapper
  include ActiveModel::Model

  attr_reader :copies
  attr_accessor :printer_name, :label_template_name, :label_template_id, :labels, :errors

  # TODO: validate
  # validate :check_attributes, :check_print_job

  def print
    # return false unless valid?

    case printer.printer_type
    when 'toshiba'
      print_to_toshiba
    when 'squix'
      print_to_squix
    end
    true
  end

  def printer
    Printer.find_by(name: printer_name)
  end

  def print_to_toshiba
    unless label_template_id
      @label_template_id = LabelTemplate.find_by(name: label_template_name).id
    end

    # labels here from LabWhere already includes the correct number of copies
    body = { printer_name: printer_name, label_template_id: label_template_id, labels: labels }

    print_job = LabelPrinter::PrintJob.build(body)
    print_job.execute
    # do something with response
  end

  def print_to_squix
    squix_print_job = Squix::PrintJob.new(
      printer_name: printer_name,
      label_template_name:
      label_template_name,
      labels: labels,
      copies: copies
    )
    squix_print_job.execute
    # do something with response
  end

  def create_response
    { message: '', status: '' }
  end

  # def check_attributes
  #   errors.add(:printer_name, 'does not exist') if printer_name.nil?
  #   errors.add(:label_template_name, 'does not exist') if label_template_name.nil?
  # end

  # def check_print_job
  # case printer.printer_type
  # when 'Toshiba'
  #   toshiba.valid?
  # when 'Squix'
  #   toshiba.valid?
  # end

  def copies=(copies)
    @copies = copies.to_i
  end
end
