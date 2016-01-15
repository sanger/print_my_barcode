module PrintJob
  class TOF < Base
    def run
      return false unless valid?
      file = File.new("#{Rails.root}/public/print_job.txt", "w+")
      file.write(template.output)
      file.close
    end
  end
end