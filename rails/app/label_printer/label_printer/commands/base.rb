module LabelPrinter
  module Commands

    ##
    # A command is something which when sent to the printer will perform a certain action
    # e.g. Feed command will feed a sheet of paper.
    # A command object will produce the necessary standard output to execute the command
    class Base

      include Commands::SetPrefix

      set_prefix "PF"

      ##
      # Each valid command requires a set of escape characters.
      ESC   = "\u001b"
      LF    = "\n"
      NUL   = "\u0000"

      ##
      # Produces the output for a command without the necessity to initialize it.
      def self.command(args = nil)
        if args.nil?
          new.to_s
        else
          new(args).to_s
        end
      end

      ##
      # The control codes are the ordered set of instructions which make up a valid command
      # without the prefix or escape characters.
      def control_codes
        "CC12345"
      end

      ##
      # A formatted command is one which has the prefix, separator and control codes.
      # e.g. PF;ABCDE12345
      def formatted(separator = '')
        "#{prefix}#{separator}#{control_codes}"
      end

      ##
      # The output which is sent to the printer includes formatted command with escape characters.
      # e.g. [ESC]PF;ABCDE12345[LF][NUL]
      def to_s
        "#{ESC}#{formatted}#{LF}#{NUL}"
      end

      ##
      # Each command has a prefix method e.g. XB?
      # This method is useless unless all other commands can respond to that method.
      # If that method does not exist the command will return false.
      # The prefix method is always of a certain format ie. one or two uppercase characters.
      def method_missing(method_name, *arguments, &block)
        if is_prefix? method_name
          false
        else
          super
        end
      end

      def respond_to_missing?(method_name, include_private = false)
        is_prefix?(method_name) || super
      end

    private 

      def is_prefix? (method_name)
        method_name.to_s =~ /[a-z]{1,2}\?/
      end

    end
  end
end