module Commands
  class Base

    include Commands::SetPrefix

    set_prefix "PF"

    ESC   = "\u001b"
    LF    = "\n"
    NUL   = "\u0000"

    def self.command(args = nil)
      if args.nil?
        new.output
      else
        new(args).output
      end
    end

    def control_codes
      "CC12345"
    end

    def formatted(separator = '')
      "#{prefix}#{separator}#{control_codes}"
    end

    def output
      "#{ESC}#{formatted}#{LF}#{NUL}"
    end

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