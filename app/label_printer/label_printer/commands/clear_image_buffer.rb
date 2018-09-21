# frozen_string_literal: true

module LabelPrinter
  module Commands
    # Image buffer clear command (C)
    class ClearImageBuffer < Commands::Base
      # Description: Clears the image buffer
      # Format: [ESC] C [LF] [NUL]

      prefix_accessor 'C'

      def control_codes
        nil
      end
    end
  end
end
