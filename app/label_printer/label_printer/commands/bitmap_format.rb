module LabelPrinter
  module Commands
    # Bit map font format command (PC)
    class BitmapFormat < Commands::Base
      include Commands::Formatting

      # Description: Sets the bit map font command
      # Format: [ESC] PCaaa; bbbb, cccc, d, e, ff (, ghh), ii, j [LF] [NUL]
      # Example: PC001;0020,0035,1,1,G,00,B
      # aaa: Character string number (000 - 199)
      # bbbb: Print origin of format of X-coordinate
      # cccc: Print origin of Y-coordinate
      # d: Character horizontal magnification
      # (Two digit designation enables magnifications in 0.5 units) e.g 05
      # e: Character vertical magnification 
      # (The magnification can be designated 
      # in 0.1 units between 0.5 to 1) e.g. 05
      # ff: Type of font mainly G (Helvetica medium)
      # ghh: Fine adjustment of character to character space.
      # g: Increase (+) or decrease (-) character to character space
      # hh: No of spaces between characters (00 - 99)
      # ii: Rotational angles of character and character string (mostly 00)
      # j: Character attribution (mostly B for black character)

      set_prefix 'PC'

      optional_attributes horizontal_magnification: '1',
                          vertical_magnification: '1',
                          font: 'G', space_adjustment: '00', 
                          rotational_angles: '00'

      def control_codes
        "#{x_origin},#{y_origin},#{horizontal_magnification},"\
        "#{vertical_magnification},"\
        "#{font},+#{space_adjustment},#{rotational_angles},B"
      end
    end
  end
end
