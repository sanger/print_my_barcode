module LabelPrinter
  module IPP
    class CharsetType < OperationAttribute

      def initialize(value_tag = "0x47", name = "attributes-charset", value = "us-ascii")
        super
      end

    end
  end
end