module LabelPrinter
  module IPP
    class Request

      attr_reader :printer_uri, :attribute_tags, :data_input
      attr_accessor :version_number, :request_id

      def initialize(printer_uri, data_input, version_number = 1.1, request_id = 1)
        @printer_uri = printer_uri
        @version_number = version_number
        @request_id = request_id
        @data_input = data_input
        @attribute_tags = AttributeTags.new(printer_uri)
      end

      def to_s
      end

      def data_length
      end

      class AttributeTags
        def initialize(printer_uri)
          @tags = [CharsetType.new, NaturalLanguageType.new, UriType.new(printer_uri)]
        end

        def to_s
          "0x01#{tags.collect(&:to_s).join}0x03"
        end

      private

        attr_reader :tags
      end
    end
  end
end