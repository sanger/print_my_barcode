module LabelPrinter
    module Commands

      # Bar code format command (XB)
      class BarcodeFormat < Commands::Base

        include Commands::Formatting

        # Description: Sets the bar code format

        # 1D:
        # Format: [ESC] XBaa; bbbb, cccc, d, e, ff, k, llll (, mnnnnnnnnnn, ooo, p, qq) [LF] [NUL] 
        # Example: XB01;0300,0000,9,3,02,0,0070,+0000000000,002,0,00
        # aa: Bar code number (00 - 31)
        # bbbb: Print origin of X-coordinate of bar code
        # cccc: Print origin of Y-coordinate of bar code
        # d: Type of bar code (mostly 5 (JAN13, EAN13) or 9 (CODE128))
        # e: Type of check digit. 
        # ff: 1-module width 0-15 in dots
        # k: rotational angle of barcode (0 - 0, 1 - 90, 2 - 180, 3 - 270)
        # iii: Height of bar code (0001 - 1000)
        # mnnnnnnnnnn: increment/decrement (optional m +/-, nnnnnnnnnn skip value 0000000000 to 9999999999)
        # ooo: Length of wpc guard bar, optional 000-1000
        # p: Selection of print or non-print numerals under bars ( optional, 0 - non-print, 1 - print)
        # qq: Number of zeros to be suppressed (optional, 00 - 20)

        # 2D:
        # Format: [ESC] XBaa; bbbb, cccc, d, ee, ff, gg, h [LF] [NUL]
        # Example: XB02;0300,0145,Q,20,03,05,1
        # aa: Bar code number (00 - 31)
        # bbbb: Print origin of X-coordinate of bar code
        # cccc: Print origin of Y-coordinate of bar code
        # d: Type of bar code
        # ee: ECC type 00 to 14: If value “00” to “14” is designated, barcode command is ignored. 20: ECC200
        # ff: 1-cell width 00 to 99 (in dots)
        # gg: Format ID No function (ignore)
        # h: Rotational angle of bar code 0: 0° 1: 90° 2: 180° 3: 270°

        set_prefix "XB"

        optional_attributes barcode_type: "5", type_of_check_digit: "3", one_module_width: "02", height: "0070", one_cell_width: "01", rotational_angle: "1"

        def control_codes
            if barcode_type == "Q"
                "#{x_origin},#{y_origin},#{barcode_type},20,#{one_cell_width},05,#{rotational_angle}"
            else
                "#{x_origin},#{y_origin},#{barcode_type},#{type_of_check_digit},#{one_module_width},0,#{height},+0000000000,002,0,00"
            end
        end
        
      end
    end
end