module LabelPrinter

  module Commands

    # Issue command (XS)
    class Issue < Commands::Base

      # Description: Issues (prints) the label
      # Format: [ESC] XS; I, aaaa, bbbcdefgh [LF] [NUL] 
      # Description: XS;I,0001,0002C3201
      # aaaa: Number of labels to be issued 0001 - 9999
      # bbb: Cut interval normally 000 no cut.
      # c: Type of sensor normally 2 (Transmissive sensor when using normal labels)
      # d: Issue mode normally C (Batch mode)
      # e: Issue speed normally 3 (3 inches/sec)
      # f: with/without ribbon normally 2 (with) 
      # g: Tag rotation normally 0 (Printing bottom first)
      # h: Type of status response normally 1 (status response)

      set_prefix "XS"

      def control_codes
        "I,0001,0002C3201"
      end

      def formatted
        super(';')
      end
      
    end
  end

end