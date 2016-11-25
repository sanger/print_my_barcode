module LabelPrinter
  module IPP

    ##
    # Create a request body as per https://tools.ietf.org/html/rfc2565
    # Internet Printing Protocol/1.0: Encoding and Transport
    # An IPP request body has the following mandatory fields (octets)
    # order / Octets / symbolic value / example
    # 1. 0x0101 version-number 1.1
    # 2. 0x0002 operation-id Print-Job
    # 3. 0x00000001 request-id 1
    # 4. 0x01 start operation-attributes
    # 5. 0x47 charset type value-tag
    # 6. 0x012 name-length
    # 7. attributes-charset name
    # 8. 0x0008 value-length
    # 9. us-ascii value
    # 10. 0x48 natural-language type value-tag
    # 11. 0x001B name-length
    # 12. attributes-natural-language name
    # 13. 0x0005 value-length
    # 14. en-us value
    # 15. 0x45 uri-type value-tag
    # 16. 0x000B name-length
    # 17. printer-uri name
    # 18. 0x001A value-length
    # 19. http://forest:631/pinetree
    # 20. 0x03 end-of-attributes
    # 21. data

    class Request

      include ActiveModel::Validations

      attr_reader :printer_uri, :attribute_tags, :data_input, :header
      attr_accessor :version_number, :request_id

      validates_presence_of :printer_uri, :data_input

      def initialize(printer_uri, data_input, version_number = 1.1, request_id = 1)
        @printer_uri = printer_uri
        @version_number = version_number
        @request_id = request_id
        @data_input = data_input
        @attribute_tags = AttributeTags.new(printer_uri)
        @header = Header.new(version_number, request_id)
      end

      def to_s
        header.to_s << attribute_tags.to_s << data_input.to_s
      end

      def data_length
        to_s.bytesize.to_s
      end

      class Header

        OPERATION_ID = "0x002"

        def initialize(version_number, request_id)
          @version_number = version_number
          @request_id = request_id
        end

        def to_s
          "#{version_number.to_hex}#{OPERATION_ID}#{request_id.to_hex(8)}"
        end

        def length
          to_s.bytesize
        end

      private
        attr_reader :version_number, :request_id
      end

      class AttributeTags

        START_OPERATION_ATTRIBUTES = "0x01"
        END_OF_ATTRIBUTES = "0x03"

        def initialize(printer_uri)
          @tags = [CharsetType.new, NaturalLanguageType.new, UriType.new(printer_uri)]
        end

        def to_s
          "#{START_OPERATION_ATTRIBUTES}#{tags.collect(&:to_s).join}#{END_OF_ATTRIBUTES}"
        end

        def length
          to_s.bytesize
        end

      private

        attr_reader :tags
      end
    end
  end
end