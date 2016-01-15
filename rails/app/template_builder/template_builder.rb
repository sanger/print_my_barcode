class TemplateBuilder

  include Commands::Outputter
  include ActiveModel::Serializers::JSON

  attr_reader :headers, :labels, :footers

  set_commands_list :set_label_size, :adjust_print_density, :adjust_position, "T", :headers, :labels, :footers

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
      headers: headers.as_json,
      labels: labels.as_json,
      footers: footers.as_json
    }
  end

  def valid?
    labels.present?
  end

  class Sections

    include ActiveModel::Serializers::JSON
    include Enumerable

    attr_reader :section_type, :sections

    def initialize(section_type, values)
      @section_type = section_type
      @sections = create_sections(values)
    end

    def as_json
      sections.collect(&:as_json)
    end

    def each(&block)
      sections.each(&block)
    end

    def output
      sections.collect { |c| c.output }.reduce(:<<)
    end

  private

    def create_sections(values)
      [].tap do |s|
        values.each do |v|
          s << TemplateSection.new(section_type, v)
        end
      end
    end
    
  end

private

  attr_reader :label_template, :template_attributes

  def create_sections(values)
    values.each do |k, v|
      set_instance_variable(k, TemplateBuilder::Sections.new(label_template.sections.find_by_type(k.singularize), v))
    end
  end

  def set_instance_variable(k, v)
    instance_variable_set "@#{k.to_s}", v
  end
  
end