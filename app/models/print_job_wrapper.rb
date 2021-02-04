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

  # There is a possibility that some of the label names will not match the
  # label names in the label template this would cause an encode error
  # which is hard to debug which we found out to our cost
  # this will tell you to check!
  # TODO: fix rubocop
  # rubocop:disable Metrics/AbcSize
  def check_label_names
    return if labels.nil? || label_template.nil?

    expected_label_names = label_template.labels.pluck(:name)
    received_label_names = labels.map { |l| l['label_name'] }.uniq

    # each item in received_label_names has to exist in expected_label_names
    return if expected_label_names & received_label_names == received_label_names

    errors.add(:label_name, 'does not match label template label names')
  end
  # rubocop:enable Metrics/AbcSize
end
