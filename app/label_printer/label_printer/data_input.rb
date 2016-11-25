module LabelPrinter

  ##
  # Manages the production of the text for the input for the printer.
  # Turns the input values into a format which can be recognised by the printer.
  module DataInput

    ##
    # Produces a new data input object from input values and a label template
    def self.build(label_template, input_values)
      LabelPrinter::DataInput::Base.new(label_template, input_values)
    end
    
  end
end