module LabelPrinter
  module DataInput

    ##
    # A DataInput::Label is related to an ActiveRecord Label
    # It also implements the Commands::Outputter
    # Each Label is made of formats and drawings which are either barcodes or bitmaps.
    # The formats and drawings are implemented as a DataInput::List

    class Label

      include LabelPrinter::Commands::Outputter
      include ActiveModel::Serializers::JSON

      attr_reader :name, :values, :formats, :drawings

      set_commands_list :formats, "C", :drawings, "XS", "C"

      ##
      # Create a list of formats and drawings
      # Find each value in the Label table and add it the formats and drawings.
      def initialize(label, values)
        @label = label
        @name = label.name
        @values = values
        @formats, @drawings = Formats.new, Drawings.new

        add_commands(values)
      end

      ##
      # Just return the passed in values.
      # No nonsens with rejigging the whole thing.
      def as_json(options = {})
        values
      end

      ##
      # A list of Barcode and Bitmap formats.
      class Formats < List
        def add(item)
          super(item.field_name, if item.barcode?
            LabelPrinter::Commands::BarcodeFormat.new(item.template_attributes)
          else
            LabelPrinter::Commands::BitmapFormat.new(item.template_attributes)
          end)
        end
      end

      ##
      # A list of Barcode and Bitmap drawings.
      class Drawings < List
        def add(item, value)
          super(item.field_name, if item.barcode?
            LabelPrinter::Commands::BarcodeDraw.new(item.padded_placeholder_id, value)
          else
            LabelPrinter::Commands::BitmapDraw.new(item.padded_placeholder_id, value)
          end)
        end
      end

    private

      attr_reader :label

      def add_commands(values)
        values.each do |k, v|
          drawing = label.drawings.find_by_field_name(k)
          formats.add(drawing)
          drawings.add(drawing, v)
        end
      end
    end
  end
end