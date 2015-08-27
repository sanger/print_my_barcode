# Bar code format command (XB)
module Commands

  class BarcodeFormat < Commands::Base

    include Commands::Formatting

    # Description: Sets the bar code format
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

    set_prefix "XB"

    optional_attributes barcode_type: "5", one_module_width: "02", height: "0070"

    def control_codes
      "#{x_origin},#{y_origin},#{barcode_type},3,#{one_module_width},0,#{height},+0000000000,002,0,00"
    end
    
  end
end