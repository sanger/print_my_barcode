module LabelPrinter
  ##
  # Manages the production of label printer interface commands
  # which make up a print job. Each command is signified by a
  # unique prefix followed by a set of control codes
  # formatted in a certain way.
  # Each command has fixed and dynamic codes.
  module Commands
    ##
    # A formatting command is one which describes the format of
    # something that will be drawn on the label either a barcode
    # or bitmap. id, x origin and y origin are added as
    # attributes. These are required. An id links the formatting
    # and drawing commands. The x origin and y origin signify where
    # the drawing will be placed on the label.
    module Formatting
      extend ActiveSupport::Concern

      included do
        attr_reader :id, :x_origin, :y_origin
      end

      module ClassMethods
        ##
        # Apart from the required attributes each format may have a
        # number of optional attributes. These can be created with a
        # default value so that they would not need to be set when
        # the template is created.
        def optional_attributes(options)
          attr_reader(*options.keys)
          define_method :set_options do |opt|
            options.each do |k, v|
              instance_variable_set "@#{k}", opt[k] || v
            end
          end
        end
      end

      ##
      # Sets all of the required and the optional attributes.
      def initialize(options = {})
        @id       = options[:id]
        @x_origin = options[:x_origin]
        @y_origin = options[:y_origin]

        set_options(options)
      end

      ##
      # Formats the output ready for a print job. 
      # This does not include escape characters.
      # Example: PF001;ABCDE1234
      def formatted(separator = ';')
        "#{prefix}#{id}#{separator}#{control_codes}"
      end
    end

    ##
    # A drawing command is linked to a format command by the id.
    # The only other attribute is the value which will be output.
    # This will either be text or barcode.
    module Drawing
      extend ActiveSupport::Concern

      included do
        attr_reader :id, :value
      end

      ##
      # Create a new drawing command and create the output.
      module ClassMethods
        def command(id, value)
          new(id, value).to_s
        end
      end

      ##
      # Set the id and value
      def initialize(id, value)
        @id = id
        @value = value
      end

      ##
      # Example: PF001;ABCDE1234
      def formatted(separator = ';')
        "#{prefix}#{id}#{separator}#{value}"
      end
    end

    ##
    # Each command has a unique prefix.
    # This module will create a couple of helper methods.
    module SetPrefix
      extend ActiveSupport::Concern

      module ClassMethods
        ##
        # e.g. set_prefix "XY" will create two methods:
        # xy? which checks the type of command and
        # prefix which will return "xy"
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

    ##
    # Allows the receiver to specify a list of commands
    # which can then be formed into valid printer output.
    # This list can include standard and derived commands.
    # The standard commands can be signified by their prefix
    # derived commands need to be a method.
    module Outputter
      extend ActiveSupport::Concern

      module ClassMethods
        ##
        # Define your list of commands.
        def set_commands_list(*list)
          define_method :commands_list do
            list
          end
        end

      end

      ##
      # The standard commands which never change.
      def standard_commands
        {
          'C'   => Commands::ClearImageBuffer,
          'T'   => Commands::Feed,
          'XS'  => Commands::Issue
        }
      end

      ##
      # Take a list of commands and execute them.
      # Returns an array of objects.
      # In the case of standard commands will just create a
      # new command.
      # With a derived command it will execute the method.
      # A derived command may itself contain a list of commands
      # so the whole thing is flattened to produce a single array.
      def commands
        @commands ||= [].tap do |c|
          commands_list.each do |command|
            if command.instance_of? String
              c << standard_commands[command].new
            else
              ret_command = send(command)
              c << (ret_command.instance_of?(Hash) ? ret_command.values : ret_command)
            end
          end
        end.flatten
      end

      ##
      # Takes an array of commands produces the output
      # and reduces it into a single string.
      # The printers use character code CP-850.
      # We need to ensure the input is encoded correctly.
      # If the data input contains anything that can't be encoded,
      # or any invalid chars, replace them with
      # a space, rather than raise an error.
      def to_s
        commands.compact.collect(&:to_s)
                .reduce(:<<)
                .encode(LabelPrinter::DEFAULT_ENCODING, 
                        invalid: :replace, undef: :replace, 
                        replace: ' ')
      end
    end
  end
end
