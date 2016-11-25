module LabelPrinter
  module IPP
    class UriType < OperationAttribute

      def initialize(value, value_tag = "0x000B", name = "printer-uri")
        super(value_tag, name, value)
      end

    end
  end
end