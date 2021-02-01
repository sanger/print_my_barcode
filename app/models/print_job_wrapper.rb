# frozen_string_literal: true

# PrintJobWrapper

# What did I do:
#
class PrintJobWrapper
  include ActiveModel::Model

  attr_accessor :printer_name, :label_template_name, :labels

  validates :label_template, :printer, :labels, presence: true

  validate :check_print_job

  def print
    return false unless valid?

    print_job.execute
  end

  def print_job
    @print_job ||= case printer.try(:printer_type)
                   when 'toshiba'
                     LabelPrinter::PrintJob.build(print_job_body.except(
                                                    :label_template_name, :copies
                                                  ))
                   when 'squix'
                     Squix::PrintJob.new(print_job_body.except(:label_template_id))
                   end
  end

  def print_job_body
    @print_job_body ||= { printer_name: printer_name, label_template_id:
                          label_template.try(:id),
                          label_template_name: label_template.try(:name),
                          labels: labels, copies: copies }
  end

  def printer
    Printer.find_by(name: printer_name)
  end

  def label_template
    LabelTemplate.find_by(name: label_template_name)
  end

  def copies=(copies)
    @copies = copies.try(:to_i)
  end

  def copies
    @copies ||= 1
  end

  private

  # TODO: we may well be double checking everything
  def check_print_job
    return if print_job.blank?
    return if print_job.valid?

    print_job.errors.each do |k, v|
      errors.add(k, v)
    end
  end
end
