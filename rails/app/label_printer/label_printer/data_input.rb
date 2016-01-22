module LabelPrinter
  module DataInput

    def self.build(label_template, values)
      LabelPrinter::DataInput::Base.new(label_template, values)
    end
    
  end
end