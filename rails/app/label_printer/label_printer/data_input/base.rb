module LabelPrinter
  module DataInput
    class Base

      include LabelPrinter::Commands::Outputter
      include ActiveModel::Serializers::JSON

      attr_reader :label_template, :template_attributes, :labels, :values

      set_commands_list :set_label_size, :adjust_print_density, :adjust_position, "T", :labels

      def initialize(label_template, input_values)
        @label_template = label_template
        @template_attributes = label_template.label_type.template_attributes
        @values = input_values
        @labels = create_labels(values)
      end

      def adjust_position
        @adjust_position ||= LabelPrinter::Commands::AdjustPosition.new(template_attributes)
      end

      def adjust_print_density
        @adjust_print_density ||= LabelPrinter::Commands::AdjustPrintDensity.new(template_attributes)
      end

      def set_label_size
        @set_label_size ||= LabelPrinter::Commands::SetLabelSize.new(template_attributes)
      end

      def as_json
        values
      end

    private

      def create_labels(values)
        List.new.tap do |list|
          values.each do |k,v|
            if v.instance_of? Array
              v.each do |hsh|
                list.append(create_labels(hsh))
              end
            else
              label = label_template.labels.find_by_name(k)
              list.add(label.name, DataInput::Label.new(label, v)) if label
            end
          end
        end
      end
      
    end
  end
end