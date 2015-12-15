module PrintJob

  class Base

    include SubclassChecker

    has_subclasses :LPD, :IPP

    attr_reader :printer, :template

    def initialize(printer, template)
      @printer = printer
      @template = template
    end

    def valid?
      printer.valid? && template.valid?
    end

    def run
    end

    def type
      self.class.to_s.demodulize.capitalize
    end
    
  end
end