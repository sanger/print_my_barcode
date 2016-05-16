module LabelPrinter
  module PrintJob

    ##
    # Not actually a print job as it is sent to a text file.
    # This is purely for debugging purposes. For example to send to a printer manually.
    # The file will be sent to Rails.root/public/print_job.txt
    class TOF < Base
      def execute
        return false unless valid?
        file = File.new("#{Rails.root}/public/print_job.txt", "w+", encoding: LabelPrinter::DEFAULT_ENCODING)
        file.write(input)
        file.close
      end
    end
  end
end