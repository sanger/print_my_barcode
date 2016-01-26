module LabelPrinter
  module DataInput

    def self.build(label_template, input_values)
      LabelPrinter::DataInput::Base.new(label_template, input_values)
    end
    
  end
end