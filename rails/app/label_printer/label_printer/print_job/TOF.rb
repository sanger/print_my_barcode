module LabelPrinter
  module PrintJob
    class TOF < Base
      def execute
        return false unless valid?
        file = File.new("#{Rails.root}/public/print_job.txt", "w+")
        file.write(data_input.output)
        file.close
      end
    end
  end
end