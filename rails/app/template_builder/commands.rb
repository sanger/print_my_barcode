module Commands
  module Formatting
    extend ActiveSupport::Concern

    included do 
      attr_reader :id, :x_origin, :y_origin
    end

    module ClassMethods
      def optional_attributes(options)
        attr_reader *options.keys
        define_method :set_options do |opt|
          options.each do |k,v|
            instance_variable_set "@#{k.to_s}", opt[k] || v
          end
        end
      end
    end

    def initialize(options = {})
      @id       = options[:id]
      @x_origin = options[:x_origin]
      @y_origin = options[:y_origin]

      set_options(options)
    end

    def output(separator = ";")
      "#{prefix}#{id}#{separator}#{control_codes}"
    end
  end

  module Drawing
    extend ActiveSupport::Concern

    included do
      attr_reader :id, :field_name
    end

    def initialize(id, field_name)
      @id = id
      @field_name = field_name
    end

    def output(separator = ";")
      "#{prefix}#{id}#{separator}{{#{field_name}}}"
    end
  end

  module SetPrefix
    extend ActiveSupport::Concern

    module ClassMethods
      def set_prefix(prefix)
        define_method "#{prefix.downcase}?" do
          true
        end
        define_method :prefix do
          prefix
        end
      end
    end
  end
end