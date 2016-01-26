module LabelPrinter
  module PrintJob

    class Base

      include ActiveModel::Model
      include ActiveModel::Serialization
      include SubclassChecker

      has_subclasses :LPD, :IPP, :TOF

      attr_accessor :printer_name, :label_template_id, :printer, :labels
      attr_reader :label_template, :data_input

      validates_presence_of :labels
      validate :check_printer, :check_label_template, :check_labels

      def initialize(attributes = {})
        super
        @printer ||= Printer.find_by_name(printer_name)
        @label_template = LabelTemplate.find_by_id(label_template_id)
        @labels ||= {}
        @data_input = LabelPrinter::DataInput::Base.new(label_template, labels) if valid?
      end

      def execute
        valid?
      end

      def type
        self.class.to_s.demodulize.capitalize
      end

    private

      def check_printer
        errors.add(:base, "Printer does not exist") unless printer
      end

      def check_label_template
        errors.add(:base, "Label template does not exist") unless label_template
      end

      def check_labels
        errors.add(:base, "There should be some labels") unless labels.any?
      end
      
    end
  end
end