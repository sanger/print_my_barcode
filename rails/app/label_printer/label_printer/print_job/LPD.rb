module LabelPrinter
  module PrintJob

    ##
    # A print job of type LPD (Line Printer Daemon)
    class LPD < Base

      ##
      # Only execute the print job if it is valid.
      # Create a temporary file of the data output and send it to the printer using the lpr system command.
      # Clean up by closing the file and removing it.
      def execute
        return false unless valid?
        temp_file = Tempfile.new('PrintJob', encoding: LabelPrinter::DEFAULT_ENCODING)
        begin
          temp_file.write(input)
          temp_file.close
          system("lpr -l -P#{printer.name} < #{temp_file.path}")
          true
        ensure
          temp_file.unlink
          false
        end

      end
    end
  end
end