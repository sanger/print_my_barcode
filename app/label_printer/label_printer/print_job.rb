# frozen_string_literal: true

# LabelPrinter::PrintJob for printers with printer type 'Toshiba'
module LabelPrinter
  ##
  # A print job will take data input,
  # format it correctly and send it to the label printer.
  # How it sends it is dependent on the printer
  # i.e. it will either be LPD or IPP.
  # TOF is also available to check that the text is
  # correct or to allow you to send a job manually.
  module PrintJob
    # This is neccessary for Travis to pass.
    # When the build method is called in tests the
    # subclasses of print job are not loaded
    # so we get a constant does not exist method.
    # TODO: modify the build method so it doesn't use constantize."
    require_relative 'print_job/base'
    require_relative 'print_job/LPD'
    require_relative 'print_job/IPP'
    require_relative 'print_job/TOF'

    ##
    # Build a new print job based on the protocol
    # of the printer name that is passed.
    # e.g. If the printer protocol is IPP it will produce
    # an object of type LabelPrinter::PrintJob::IPP
    # If the printer name is not passed or it is an
    # invalid printer then it will produce an object of type
    # LabelPrinter::PrintJob::Base. As it is not attached
    # to a printer if you try to execute the print job
    # nothing will happen.
    def self.build(attributes)
      printer = Printer.find_by(name: attributes[:printer_name])
      if printer.present?
        "LabelPrinter::PrintJob::#{printer.protocol}"
          .constantize.new(attributes.merge(printer:))
      else
        LabelPrinter::PrintJob::Base.new(attributes)
      end
    end

    # If the data is coming from v2 then we need to convert the labels
    # into a compatible format
    def self.build_from_v2(attributes)
      build(attributes.merge(labels: convert_labels(attributes[:labels])))
    end

    # Example labels from v2:
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
    # and v1 equivalent
    # {
    #  "body" => [{
    #   "main_label" => {
    #   "right_text"=>"DN9000003B",
    #   "left_text"=>"DN9000003B",
    #   "barcode"=>"DN9000003B",
    #
    # }},
    # { "extra_label" => {
    #   "extra_right_text"=>"DN9000003B  LTHR-384 RT",
    #   "extra_left_text"=>"10-NOV-2020"
    # }}]
    # }
    def self.convert_labels(labels)
      return if labels.nil?

      labels_with_location = labels.map do |label|
        label_name = label[:label_name]

        # we need to remove the label_name otherwise it will cause a failure
        { label_name => label.except(:label_name) }
      end
      { body: labels_with_location }
    end
  end
end
