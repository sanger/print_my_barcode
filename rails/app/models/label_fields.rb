class LabelFields

  attr_reader :labels

  def initialize
    yield self if block_given?
  end

  def add(label)
    labels[label.name.to_sym] = label.field_names
  end

  def labels
    @labels ||= OpenStruct.new
  end

  def to_h
    labels.to_h.with_indifferent_access
  end

  def find(key)
    labels[key.to_sym]
  end

  def dummy_labels
    @dummy_labels ||= DummyLabels.new(labels)
  end

  class DummyLabels

    PLACEHOLDERS = [:header, :footer]

    attr_reader :values

    def initialize(labels)
      labels.each_pair do |k, v|
        values[k] = keys_to_values(v)
      end
    end

    def find(key)
      values[key.to_sym]
    end

    def values
      @values ||= OpenStruct.new
    end

    def to_h
      values.to_h.slice(*PLACEHOLDERS).merge({body: labels}).with_indifferent_access
    end

    def actual_count
      values.to_h.reduce(0) do |result, (k,v)|
        result += (PLACEHOLDERS.include?(k) ? 1 : 2)
      end
    end

  private

    def labels
      hsh = values.to_h.except(*PLACEHOLDERS)
      [hsh, hsh]
    end

    def keys_to_values(values)
      Hash[values.collect { |v| [v,v]}]
    end
  end

end