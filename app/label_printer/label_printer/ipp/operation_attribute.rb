module LabelPrinter
  module IPP
    class OperationAttribute

      attr_reader :value_tag, :name, :value

      def initialize(value_tag, name, value)
        @value_tag = value_tag
        @name = name
        @value = value
      end

      def name_length
        name.length.to_hex(4)
      end

      def value_length
        value.length.to_hex(4)
      end

      def to_s
        "#{value_tag}#{name_length}#{name}#{value_length}#{value}"
      end
    end
  end
end