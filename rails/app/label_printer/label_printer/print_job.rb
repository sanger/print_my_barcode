module LabelPrinter
  module PrintJob
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