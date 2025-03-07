# frozen_string_literal: true

module LabelPrinter
  module Commands
    # Bar code format command (XB)
    class BarcodeFormat < Commands::Base
      include Commands::Formatting

      # Description: Sets the bar code format

      # 1D:
      # Format: [ESC] XBaa; bbbb, cccc, d, e, ff, k,
      # llll (, mnnnnnnnnnn, ooo, p, qq) [LF] [NUL]
      # Example: XB01;0300,0000,9,3,02,0,0070,+0000000000,002,0,00
      # aa: Bar code number (00 - 31)
      # bbbb: Print origin of X-coordinate of bar code
      # cccc: Print origin of Y-coordinate of bar code
      # d: Type of bar code (mostly 5 (JAN13, EAN13) or 9 (CODE128))
      # e: Type of check digit.
      # ff: 1-module width 0-15 in dots
      # k: rotational angle of barcode (0 - 0, 1 - 90, 2 - 180, 3 - 270)
      # iii: Height of bar code (0001 - 1000)
      # mnnnnnnnnnn: increment/decrement
      # (optional m +/-, nnnnnnnnnn skip value 0000000000 to 9999999999)
      # ooo: Length of wpc guard bar, optional 000-1000
      # p: Selection of print or non-print numerals under bars
      # ( optional, 0 - non-print, 1 - print)
      # qq: Number of zeros to be suppressed (optional, 00 - 20)

      # 2D:
      # Barcode type: Q
      # Format: [ESC] XBaa; bbbb, cccc, d, ee, ff, gg, h [LF] [NUL]
      # Example: XB02;0300,0145,Q,20,03,05,1
      # aa: Bar code number (00 - 31)
      # bbbb: Print origin of X-coordinate of bar code
      # cccc: Print origin of Y-coordinate of bar code
      # d: Type of bar code
      # ee: ECC type 00 to 14: If value "00" to "14" is designated,
      # barcode command is ignored. 20: ECC200
      # ff: 1-cell width 00 to 99 (in dots)
      # gg: Format ID No function (ignore)
      # h: Rotational angle of bar code 0: 0° 1: 90° 2: 180° 3: 270°

      # PDF417
      # Barcode type: P
      # Format: [ESC] XBaa; bbbb, cccc, d, ee, ff, gg, h, iiii [LF] [NUL]
      # Example: XB02,0300,0000,P,00,01,10,0,0100
      # aa: Bar code number (00 - 31)
      # bbbb: Print origin of X-coordinate of bar code
      # cccc: Print origin of Y-coordinate of bar code
      # d: Type of bar code
      # ee: Security level defaults to 00 (Level 0)
      # ff: 1-module width 0-15 in dots
      # gg: No of columns (01-30)
      # h: rotational angle of barcode (0 - 0, 1 - 90, 2 - 180, 3 - 270)
      # iiii: Bar height (0000 - 0100 in 0.1mm units)

      # CODE39
      # Barcode type: 3 or B
      # [ESC] XBaa; bbbb, cccc, d, e, ff, gg, hh, ii, jj, k, llll [LF] [NUL]
      # Example: XB02,0300,0000,3,3,01,01,01,01,01,1,0100
      # aa: Bar code number (00 - 31)
      # bbbb: Print origin of X-coordinate of bar code
      # cccc: Print origin of Y-coordinate of bar code
      # d: Type of bar code
      # e: type of check digit
      # ff: Narrow bar width (01 to 99 (in dots))
      # gg: Narrow space width (01 to 99 (in dots))
      # hh: Wide bar width (01 to 99 (in dots))
      # ii: Wide space width (01 to 99 (in dots))
      # jj: Character-to-character space width (01 to 99 (in dots))
      # k: rotational angle of barcode (0 - 0, 1 - 90, 2 - 180, 3 - 270)
      # llll: Height of the bar code (0000 - 0100 in 0.1mm units)

      prefix_accessor 'XB'

      optional_attributes barcode_type: '5', type_of_check_digit: '3',
                          one_module_width: '02', height: '0070',
                          one_cell_width: '04', rotational_angle: '1',
                          no_of_columns: '01', bar_height: '0010',
                          narrow_bar_width: '01', narrow_space_width: '01',
                          wide_bar_width: '01',
                          wide_space_width: '01', char_to_char_space_width: '01'

      # TODO: Modify method to stop rubocop errors.
      def control_codes
        return twod_codes if barcode_type == 'Q'
        return pdf417_codes if barcode_type == 'P'
        return code39_codes if %w[3 B].include?(barcode_type)

        oned_codes
      end

      private

      def standard_codes
        "#{x_origin},#{y_origin},#{barcode_type}"
      end

      def pdf417_codes
        "#{standard_codes},00,#{one_module_width},#{no_of_columns}," \
          "0,#{bar_height}"
      end

      def twod_codes
        "#{standard_codes},20,#{one_cell_width},05,#{rotational_angle}"
      end

      def oned_codes
        "#{standard_codes},#{type_of_check_digit},#{one_module_width}," \
          "0,#{height},+0000000000,002,0,00"
      end

      def code39_codes
        "#{standard_codes},#{type_of_check_digit},#{narrow_bar_width},#{narrow_space_width}," \
          "#{wide_bar_width},#{wide_space_width},#{char_to_char_space_width}," \
          "#{rotational_angle},#{height}"
      end
    end
  end
end
