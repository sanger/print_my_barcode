module LabelPrinter
  module DataInput

    ##
    # A special type of list.
    # To make the labels easy to find they are added to a hash.
    # Label names are duplicated and adding these to a
    # normal hash will cause data loss.
    # Therefore each name is made unique by adding
    # an integer to the end e.g. my_label_1
    # We still need to find these by the key without
    # the integer so this type of list adds
    # various methods to support that.
    # This list also supports the Commands::Outputter so
    # it can be turned into formatted
    # text for the label printer.
    class List
      include Enumerable
      include LabelPrinter::Commands::Outputter

      attr_reader :items

      set_commands_list :items

      def initialize
        @items = {}
        yield self if block_given?
      end

      ##
      # This will find any items matching the same key and
      # increment the count by 1.
      # e.g. list.add("my_key", item) where there are three
      # items with a similar key.
      # will add an item with key "my_key_4"
      def add(key, item)
        items["#{key}_#{select(key).count + 1}"] = item
        self
      end

      ##
      # select all of the items which match the key.
      # e.g. select("my_key") where matching keys
      # are ["my_key_1", "my_key_2", "my_key_3"]
      # would return a hash of three items.
      def select(key)
        items.select { |k, _| k.match(/\A#{key}_\d+\z/) }
      end

      ##
      # Append one list to another.
      # It may be the case that the other list will
      # have duplicate keys.
      # Therefore rather than just merging the two lists
      # each item is added manually and if
      # necessary renaming the key.
      def append(list)
        list.items.each do |k, v|
          add(sanitize_key(k), v)
        end
      end

      ##
      # Firstly select all of the keys which match key
      # If there are no matching keys return nil.
      # If there is only one key that matches return the value
      # If no to any of the above return a hash of matching keys.
      def find(key)
        selection = select(key)
        return nil if selection.empty?
        return selection.values.first if selection.count == 1
        selection
      end

      ##
      # Return the first items which matches
      def find_by(key)
        selection = find(key)
        selection.instance_of?(Hash) ? selection.values.first : selection
      end

      ##
      # remove the last part of the key.
      # e.g. my_key_1 becomes my_key
      def sanitize_key(key)
        *bits, _ = key.split('_')
        bits.join('_')
      end

      ##
      # We only need to loop through the values not the keys
      def each(&block)
        items.values.each(&block)
      end
    end
  end
end
