module LabelPrinter
  module Commands
    # Label size set command (D)
    class SetLabelSize < Commands::Base
      
      # Description: Sets the label size
      # Format: [ESC] Daaaa, bbbb, cccc [LF] [NUL]
      # Example: D0110,0920,0080
      # aaaa: Pitch length of label
      # bbbb: Effective print width
      # cccc: Effective print length

      set_prefix 'D'

      attr_reader :pitch_length, :print_width, :print_length

      def initialize(options = {})
        @pitch_length = options[:pitch_length]
        @print_width = options[:print_width]
        @print_length = options[:print_length]
      end

      def control_codes
        "#{pitch_length},#{print_width},#{print_length}"
      end
    end
  end
end
