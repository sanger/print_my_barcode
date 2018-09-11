# frozen_string_literal: true

module LabelPrinter
  module DataInput
    ##
    # A data input will create a list of commands which can be output
    # as text for a single print job.
    # Implements Commands::Outputter so everything can by output to a
    # beautiful long string.
    # It will always have the same format which will be:
    # 1. A set label size command
    # 2. An adjust print density command
    # 3. An adjust position command
    # 4. A feed command
    # 5. A list of labels including all of the command which make them up.
    class Base
      include LabelPrinter::Commands::Outputter
      include ActiveModel::Serializers::JSON

      attr_reader :label_template, :template_attributes, :labels, :values

      commands_list_reader :set_label_size, :adjust_print_density,
                           :adjust_position, 'T', :labels

      ##
      # The labels are created from the input values and turned into a list
      # each label will have a name.
      # A value may be an array of labels in which case these are turned into a
      # list and appended to the existing list.
      # The outcome is a single list of labels which can be magically turned into
      # a string for outputting to the printer.
      def initialize(label_template, input_values)
        @label_template = label_template
        @template_attributes = label_template.label_type.template_attributes
        @values = input_values
        @labels = create_labels(values)
      end

      ##
      # Create an AdjustPosition command
      def adjust_position
        @adjust_position ||=
          LabelPrinter::Commands::AdjustPosition.new(template_attributes)
      end

      ##
      # Create an AdjustPrintDensity command
      def adjust_print_density
        @adjust_print_density ||=
          LabelPrinter::Commands::AdjustPrintDensity.new(template_attributes)
      end

      ##
      # Create a SetLabelSize command
      def set_label_size
        @set_label_size ||=
          LabelPrinter::Commands::SetLabelSize.new(template_attributes)
      end

      ##
      # return the values as is
      def as_json(*)
        values
      end

      ##
      # Only valid if there are some labels
      def valid?
        labels.any?
      end

      private

      def create_labels(values)
        List.new.tap do |list|
          values.each do |k, v|
            if v.instance_of? Array
              add_labels(list, v)
            else
              add_label(list, k, v)
            end
          end
        end
      end

      def add_labels(list, values)
        values.each { |hsh| list.append(create_labels(hsh)) }
      end

      def add_label(list, key, value)
        label = label_template.labels.detect { |l| l.name == key }
        list.add(label.name, DataInput::Label.new(label, value)) if label.present?
      end
    end
  end
end
