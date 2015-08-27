#Image buffer clear command (C)

module Commands

  # Description: Clears the image buffer
  # Format: [ESC] C [LF] [NUL]

  class ClearImageBuffer < Commands::Base

    set_prefix "C"

    def control_codes
      nil
    end
  end
end