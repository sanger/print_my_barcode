##
# For a label template will produce a list of field names for each label.
# For example a label template may have the following:
#  label_1: { barcode_1, barcode_2, bitmap_1, bitmap_2 }
#  label_2: { barcode_3, barcode_4, bitmap_3, bitmap_4 }
# This is useful for interogating the api so as to send a valid print job
class LabelFields
  attr_reader :labels

  def initialize
    yield self if block_given?
  end

  ##
  # Add a label with a key which is the name of the label
  # value is the list of field names for that label
  def add(label)
    labels[label.name.to_sym] = label.field_names
  end

  def labels
    @labels ||= OpenStruct.new
  end

  def to_h
    labels.to_h.with_indifferent_access
  end

  ##
  # returns the field names for the label signified by key
  def find(key)
    labels[key.to_sym]
  end

  ##
  # Produce a DummyLabels object which can be used for testing purposes.
  # Particularly for internal tests or api testing.
  # Saves manually creating json
  def dummy_labels
    @dummy_labels ||= DummyLabels.new(labels)
  end

  ##
  # Simulate a valid json object
  # Creates a header, footer and body which will be an array of labels
  class DummyLabels
    PLACEHOLDERS = [:header, :footer].freeze

    attr_reader :values

    ##
    # Produces a hash for each key.
    # e.g. 
    #  dummy_labels = DummyLabels.new({label_1: [:field_1, 
    #                 :field_2], label_2: [:field_3, :field_4]})
    #  dummy_labels.values => #<OpenStruct: label_1: 
    #  {field_1: "field_1", field_2: "field_2"}, label_2: 
    #  {field_3: "field_3", field_4: "field_4"}>
    def initialize(labels)
      labels.each_pair do |k, v|
        values[k] = keys_to_values(v)
      end
    end

    ##
    # find value for key
    def find(key)
      values[key.to_sym]
    end

    ##
    # Labels is of type OpenStruct
    def values
      @values ||= OpenStruct.new
    end

    ##
    # produces a hash from the open struct.
    # for any label that is not a header or footer will produce two copies 
    # which will be appended to the hash as an array
    # of key body
    # e.g.
    #  dummy_labels = DummyLabels.new({label_1: [:field_1, :field_2], 
    #  label_2: [:field_3, :field_4], header: [:field_5, :field_6], footer: [:field_7, :field_8]})
    #  dummy_labels.to_h =>
    #  { header: {field_5: "field_5", field_6: "field_6"}, 
    #    footer: {field_7: "field_7", field_8: "field_8"}, 
    #    body: [{ label_1: {field_1: "field_1", field_2: "field_2"}, 
    #    label_2: {field_3: "field_3", field_4: "field_4"} }, 
    #    { label_1: {field_1: "field_1", field_2: "field_2"}, 
    #    label_2: {field_3: "field_3", field_4: "field_4"} }]}
    def to_h
      values.to_h.slice(*PLACEHOLDERS).merge(body: labels)
            .with_indifferent_access
    end

    ##
    # The actual count includes the doubling of labels that are not header or footer
    def actual_count
      values.to_h.reduce(0) do |result, (k, _)|
        result + (PLACEHOLDERS.include?(k) ? 1 : 2)
      end
    end

    private

    def labels
      hsh = values.to_h.except(*PLACEHOLDERS)
      [hsh, hsh]
    end

    def keys_to_values(values)
      Hash[values.collect { |v| [v, v] }]
    end
  end
end
