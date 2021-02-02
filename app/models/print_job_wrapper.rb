# frozen_string_literal: true

# PrintJobWrapper

# What did I do:
# added validation for required attributes as well as print job
# added validation for print job
# added print job creation in single method
# added print job body creation method
# made copies optional and create them if they are not passed
# created printer and label template as attribute readers
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
                     LabelPrinter::PrintJob.build_from_v2(print_job_body.except(
                                                            :label_template_name, :copies
                                                          ))
                   when 'squix'
                     Squix::PrintJob.new(squix_print_job_body)
                   end
  end

  def print_job_body
    @print_job_body ||= {
      printer_name: printer_name,
      label_template_id: label_template.try(:id),
      label_template_name: label_template.try(:name),
      labels: labels,
      copies: copies
    }
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

  def squix_print_job_body
    return if labels.nil?

    squix_labels = print_job_body[:labels].collect { |l| l.except(:label_name) }
    print_job_body.except(:label_template_id).merge(labels: squix_labels)
  end
end
