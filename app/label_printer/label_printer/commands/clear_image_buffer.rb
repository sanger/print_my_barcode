module LabelPrinter
  module Commands
    # Image buffer clear command (C)
    class ClearImageBuffer < Commands::Base

      # Description: Clears the image buffer
      # Format: [ESC] C [LF] [NUL]

      set_prefix 'C'

      def control_codes
        nil
      end
    end
  end
end
