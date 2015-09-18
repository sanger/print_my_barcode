class TemplateSection

  include SubclassChecker
  include Commands::Outputter

  has_subclasses :header, :footer, :label

  attr_reader :type, :section, :formats, :drawings, :values

  set_commands_list :formats, "C", :drawings, "XS", "C"

  def initialize(section, values)
    @section = section
    @values = values
    @type = section.type

    add_placeholders
  end

  def formats
    @formats ||= []
  end

  def drawings
    @drawings ||= []
  end

private
  
  def add_placeholders
    values.each do |k, v|
      drawing = section.drawings.find_by_field_name(k)
      if drawing.barcode?
        formats << Commands::BarcodeFormat.new(drawing.template_attributes)
        drawings <<  Commands::BarcodeDraw.new(drawing.padded_placeholder_id, v)
      else
        formats << Commands::BitmapFormat.new(drawing.template_attributes)
        drawings << Commands::BitmapDraw.new(drawing.padded_placeholder_id, v)
      end
    end
  end
end
