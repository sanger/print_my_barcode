# frozen_string_literal: true

module Squix
  # labels:
  # [{
  #   "right_text"=>"DN9000003B",
  #   "left_text"=>"DN9000003B",
  #   "barcode"=>"DN9000003B",
  #   "extra_right_text"=>"DN9000003B  LTHR-384 RT",
  #   "extra_left_text"=>"10-NOV-2020"
  # }]

  # Squix::PrintJob
  class PrintJob
    include ActiveModel::Model

    attr_accessor :printer_name, :label_template_name, :labels, :copies

    validates :printer_name, :label_template_name, :labels, :copies, presence: true

    def execute
      SPrintClient.send_print_request(
        printer_name,
        label_template_name,
        merge_fields_list
      )
    end

    def merge_fields_list
      labels * copies
    end
  end
end
