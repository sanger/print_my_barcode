module PrintJob

  def self.build(printer, template)
    "PrintJob::#{printer.protocol}".constantize.new(printer, template)
  end
end