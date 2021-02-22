# frozen_string_literal: true

module Squix
  # labels:
  # [{
  #   "right_text"=>"DN9000003B",
  #   "left_text"=>"DN9000003B",
  #   "barcode"=>"DN9000003B",
  #   "label_name"=>"main_label"
  # },
  # {
  #   "extra_right_text"=>"DN9000003B  LTHR-384 RT",
  #   "extra_left_text"=>"10-NOV-2020"
  #   "label_name"=>"extra_label"
  # }]

  # Squix::PrintJob
  class PrintJob
    include ActiveModel::Model

    attr_accessor :printer_name, :label_template_name, :labels, :copies

    validates :printer_name, :label_template_name, :labels, :copies, presence: true

    def execute
      response = SPrintClient.send_print_request(
        printer_name,
        "#{label_template_name}.yml.erb",
        merge_fields_list
      )

      # Response contains error message, if required
      return false unless response.code == '200'

      true
    end

    def merge_fields_list
      converted_labels * copies
    end

    def converted_labels
      return if labels.nil?

      labels.collect { |l| l.except(:label_name) }
    end
  end
end
