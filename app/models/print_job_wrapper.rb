# frozen_string_literal: true

# PrintJobWrapper
class PrintJobWrapper
  include ActiveModel::Model

  attr_reader :copies
  attr_accessor :printer_name, :label_template_name, :label_template_id, :labels

  validate :check_printer

  def print
    return false unless valid?

    unless print_job.valid?
      print_job.errors.each do |k, v|
        errors.add(k, v)
      end
      return false
    end

    print_job.execute
  end

  def print_job
    case printer.printer_type
    when 'toshiba'
      @print_job ||= toshiba_print_job
    when 'squix'
      @print_job ||= squix_print_job
    end
  end

  def toshiba_print_job
    LabelPrinter::PrintJob.build(print_job_body)
  end

  def squix_print_job
    Squix::PrintJob.new(print_job_body)
  end

  def print_job_body
    case printer.printer_type
    when 'toshiba'
      unless label_template_id
        @label_template_id = LabelTemplate.find_by(name: label_template_name).id
      end
      @print_job_body = { printer_name: printer_name, label_template_id: label_template_id,
                          labels: labels }
    when 'squix'
      @print_job_body = { printer_name: printer_name, label_template_name: label_template_name,
                          labels: labels, copies: copies }
    end
  end

  def printer
    Printer.find_by(name: printer_name)
  end

  def copies=(copies)
    @copies = copies.to_i
  end

  private

  def check_printer
    errors.add(:printer, 'does not exist') if printer.blank?
  end
end
