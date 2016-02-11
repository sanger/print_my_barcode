module LabelPrinter

  ##
  # A print job will take data input, format it correctly and send it to the label printer.
  # How it sends it is dependent on the printer i.e. it will either be LPD or IPP.
  # TOF is also available to check that the text is correct or to allow you to send a job manually.
  module PrintJob

    ##
    # Build a new print job based on the protocol of the printer name that is passed.
    # e.g. If the printer protocol is IPP it will produce an object of type LabelPrinter::PrintJob::IPP
    # If the printer name is not passed or it is an invalid printer then it will produce an object of type
    # LabelPrinter::PrintJob::Base. As it is not attached to a printer if you try to execute the print job
    # nothing will happen.
    def self.build(attributes)
      printer = Printer.find_by_name(attributes[:printer_name])
      if printer
        "LabelPrinter::PrintJob::#{printer.protocol}".constantize.new(attributes.merge(printer: printer))
      else
        LabelPrinter::PrintJob::Base.new(attributes)
      end
    end
  end
end