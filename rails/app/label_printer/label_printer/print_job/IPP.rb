module LabelPrinter
  module PrintJob

    ##
    # A print job of type IPP (Internet Printing Protocol)
    class IPP < Base

      attr_reader :headers, :request_body, :printer_uri, :http

      def initialize(attributes = {})
        super
        @printer_uri = URI::HTTP.build(host: printer.name, path: "/ipp", port: 631)
        @request_body = LabelPrinter::IPP::Request.new(printer_uri.to_s, data_input)
        @headers = { 'Content-Type' => 'application/ipp', 'Content-Length' => request_body.data_length}
        @http = Net::HTTP.new(printer_uri.host, printer_uri.port)
      end

      def execute
        return false unless valid?
        response = http.post(printer_uri.path, request_body.to_s, headers)
        if response.code == 200
          true
        else
          false
        end
      end
      
    end
  end
end