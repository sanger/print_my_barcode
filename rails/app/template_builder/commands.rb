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

    def formatted(separator = ";")
      "#{prefix}#{id}#{separator}#{control_codes}"
    end
  end

  module Drawing
    extend ActiveSupport::Concern

    included do
      attr_reader :id, :value
    end

    module ClassMethods
      def command(id, value)
        new(id, value).output
      end
    end

    def initialize(id, value)
      @id = id
      @value = value
    end

    def formatted(separator = ";")
      "#{prefix}#{id}#{separator}#{value}"
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

  module Outputter
    extend ActiveSupport::Concern

    module ClassMethods
      def set_commands_list(*list)
        define_method :commands_list do
          list
        end
      end

    end

    def standard_commands
      {
        "C"   => Commands::ClearImageBuffer,
        "T"   => Commands::Feed,
        "XS"  => Commands::Issue
      }
    end

    def commands
      @commands ||= [].tap do |c|
        commands_list.each do |command|
          if command.instance_of? String
            c << standard_commands[command].new
          else
            c << self.send(command)
          end
        end
      end.flatten
    end

    def output
      commands.compact.collect { |c| c.output }.reduce(:<<)
    end
  end
end