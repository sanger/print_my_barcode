class LabelFields

  SECTIONS = [:header, :label, :footer]

  attr_reader *SECTIONS

  def initialize
    yield self if block_given?
  end

  def add(section, field_names)
    instance_variable_set("@#{section.to_s}", field_names)
  end

  def dummy_values
    SECTIONS.inject({}) do |result, section|
      result[section] = Hash[instance_variable_get("@#{section.to_s}").collect { |v| [v,v]}]
      result
    end.with_indifferent_access
  end
  
end