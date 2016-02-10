module LabelPrinter
  module Commands

    # Position fine adjust command (AX)
    class AdjustPosition < Commands::Base

      # Description: Adjusts the feed length, cut position and back feed length.
      # Format: [ESC] AX; abbb, cddd, eff [LF] [NUL]
      # Example: AX;+004,+000,+00
      # a: direction in which fine adjustment to be made forward(+) or backward(-) normally backward.
      # bbb: Feed value to be finely adjusted (000 - 500)
      # c: direction forward (-) or backward (+) in which a cut position fine adjustment is to be made.
      # ddd: Amount for finely adjusting the cut position (000 - 180)
      # e: Indicates whether the back feed is to be increased (+) or decreased (-) 
      # ff: Amount for finely adjusting the back feed (00 - 99)

      set_prefix "AX"

      attr_reader :feed_value

      def initialize(options = {})
        @feed_value = options[:feed_value]
      end

      def control_codes
        "+#{feed_value},+000,+00"
      end

      def formatted
        super(';')
      end

    end

      
  end
end