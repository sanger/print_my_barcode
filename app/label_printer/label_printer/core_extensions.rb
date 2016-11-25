module LabelPrinter
  module CoreExtensions

    module Fixnum
      def to_hex(padding = 2)
        "0x" << sprintf("%0#{padding}X", self.to_s)
      end
    end

    module Float
      def to_hex
        "0x" << self.to_s.split(".").collect { |n| sprintf("%02X", n) }.join
      end
    end
  end
end

