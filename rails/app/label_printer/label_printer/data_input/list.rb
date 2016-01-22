module LabelPrinter
  module DataInput
    class List

      include Enumerable
      include LabelPrinter::Commands::Outputter

      attr_reader :items

      set_commands_list :items

      def initialize
        @items = {}
        yield self if block_given?
      end

      def add(key, item)
        items["#{key}_#{select(key).count+1}"] = item
        self
      end

      def select(key)
        items.select { |k,v| k.match(/\A#{key}_\d+\z/)}
      end

      def append(list)
        list.items.each do |k,v|
          add(sanitize_key(k), v)
        end
      end

      def find(key)
        selection = select(key)
        return nil if selection.empty?
        return selection.values.first if selection.count == 1
        selection
      end

      def find_by(key)
        selection = find(key)
        selection.instance_of?(Hash) ? selection.values.first : selection
      end

      def sanitize_key(key)
        *bits, last = key.split('_')
        bits.join('_')
      end

      def each(&block)
        items.values.each(&block)
      end
    end
  end
end