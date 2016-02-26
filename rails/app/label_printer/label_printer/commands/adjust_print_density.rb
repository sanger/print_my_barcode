module LabelPrinter

  module Commands

    #Print density fine adjust command (AY)

    class AdjustPrintDensity < Commands::Base

      # description: Adjusts the print density
      # Format: [ESC] AY; abb, c [LF] [NUL]
      # Example: AY;+08,0
      # a: Increase (+) or decrease (-) the density
      # bb: Print density fine adjustment command (00 - 10)
      # c: Mode for fine adjustment thermal transfer (0) or direct transfer (1)

      set_prefix "AY"

      attr_reader :fine_adjustment

      def initialize(options = {})
        @fine_adjustment = options[:fine_adjustment]
      end

      def control_codes
        "+#{fine_adjustment},0"
      end

      def formatted
        super(';')
      end
    end

  end

end