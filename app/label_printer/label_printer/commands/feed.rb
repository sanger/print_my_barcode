# frozen_string_literal: true

module LabelPrinter
  module Commands
    # Feed command (T)
    class Feed < Commands::Base
      # Description: Feeds one sheet of paper
      # and aligns it with the first printing position.
      # Format: [ESC] Tabcde [LF] [NUL]
      # Example: T20C32

      prefix_accessor 'T'

      def control_codes
        '20C32'
      end
    end
  end
end
