# frozen_string_literal: true

module Squix
  # Squix::PrintJobWrapper
  class PrintJobWrapper
    include ActiveModel::Model

    attr_accessor :printer_name, :label_template_name, :label_template_id, :labels, :copies, :errors

    # validate

    def initialize(printer_name, label_template_name, label_template_id, labels, copies)
      @printer_name = printer_name
      @label_template_name = label_template_name
      @label_template_id = label_template_id
      @labels = labels
      @copies = copies.to_i
      @errors = []
    end

    def print
      # return false unless valid?

      case printer_type
      when 'Toshiba'
        print_to_toshiba
      when 'Squix'
        print_to_squix
      else
        errors << "Printer type #{printer_type} for printer #{printer_name} not recognised."
        false
      end
    end

    def printer_type
      Printer.find_by(name: printer_name).type
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
  end
end
