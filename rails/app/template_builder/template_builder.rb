class TemplateBuilder

  include Commands::Outputter
  include ActiveModel::Serializers::JSON

  attr_reader :header, :label, :footer

  set_commands_list :set_label_size, :adjust_print_density, :adjust_position, "T", :header, :label, :footer

  def initialize(label_template, values)
    @label_template = label_template
    @template_attributes = label_template.label_type.template_attributes

    create_sections(values)
  end

  def adjust_position
    @adjust_position ||= Commands::AdjustPosition.new(template_attributes)
  end

  def adjust_print_density
    @adjust_print_density ||= Commands::AdjustPrintDensity.new(template_attributes)
  end

  def set_label_size
    @set_label_size ||= Commands::SetLabelSize.new(template_attributes)
  end

  def as_json(options = {})
    {
      header: header.as_json,
      label: label.as_json,
      footer: footer.as_json
    }
  end

private

  attr_reader :label_template, :template_attributes

  def create_sections(values)
    values.each do |k, v|
      set_instance_variable(k, TemplateSection.new(label_template.sections.find_by_type(k), v))
    end
  end

  def set_instance_variable(k, v)
    instance_variable_set "@#{k.to_s}", v
  end
  
end