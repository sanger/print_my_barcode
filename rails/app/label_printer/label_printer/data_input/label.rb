module LabelPrinter
  module DataInput
    class Label

      include LabelPrinter::Commands::Outputter
      include ActiveModel::Serializers::JSON

      attr_reader :name, :values, :formats, :drawings

      set_commands_list :formats, "C", :drawings, "XS", "C"

      def initialize(label, values)
        @label = label
        @name = label.name
        @values = values
        @formats, @drawings = Formats.new, Drawings.new

        add_commands(values)
      end

      def as_json
        values
      end

      class Formats < List
        def add(item)
          super(item.field_name, if item.barcode?
            LabelPrinter::Commands::BarcodeFormat.new(item.template_attributes)
          else
            LabelPrinter::Commands::BitmapFormat.new(item.template_attributes)
          end)
        end
      end

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