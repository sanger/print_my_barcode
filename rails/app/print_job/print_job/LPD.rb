module PrintJob
  class LPD < Base
    
    def run
      return false unless valid?
      temp_file = Tempfile.new('PrintJob')
      begin
        temp_file.write(template.output)
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