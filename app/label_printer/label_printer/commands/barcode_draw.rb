module LabelPrinter

  module Commands
    #Bar code data command (RB)
    class BarcodeDraw < Commands::Base

      # Description: Draws bar code data
      # Format: [ESC] RBaa; bbb ------ bbb [LF] [NUL] 
      # Example: RB01;{{barcode}}
      # aa: Bar code number 00 - 31
      # bbb ------ bbb: Data string to be printed

      include Commands::Drawing

      set_prefix "RB"
      
    end
  end

end