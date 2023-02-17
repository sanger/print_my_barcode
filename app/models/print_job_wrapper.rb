# frozen_string_literal: true

# PrintJobWrapper
class PrintJobWrapper
  include ActiveModel::Model

  attr_accessor :printer_name, :label_template_name, :labels

  validates :label_template, :printer, :labels, presence: true

  validate :check_print_job, :check_label_names

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
                     Squix::PrintJob.new(print_job_body.except(:label_template_id))
                   end
  end

  def print_job_body
    @print_job_body ||= {
      printer_name:,
      label_template_id: label_template.try(:id),
      label_template_name: label_template.try(:name),
      labels:,
      copies:
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

    print_job.errors.each do |error|
      errors.add(error.attribute, error.message)
    end
  end

  # There is a possibility that some of the label names will not match the
  # label names in the label template this would cause an encode error
  # which is hard to debug which we found out to our cost
  # this will tell you to check!
  def check_label_names
    return if labels.nil? || label_template.nil?

    # extract the label names for the label template
    expected_labels = label_template.labels.pluck(:name)

    # pull out the label names that are received in the request
    received_labels = labels.pluck('label_name').uniq

    return if labels_match(expected_labels, received_labels)

    errors.add(:label_name, 'does not match label template label names')
  end

  # uses the array intersection method
  def labels_match(expected, received)
    expected & received == received
  end
end
