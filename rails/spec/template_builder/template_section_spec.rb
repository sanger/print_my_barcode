require "rails_helper"

RSpec.describe TemplateSection, type: :model do |variable|

  let!(:header)         { create(:header_with_drawings) }
  let(:values)          { header.drawings.pluck(:field_name).to_h_derived }
  let(:header_section)  { TemplateSection.new(header, values) }

  it "should have the correct type" do
    expect(header_section).to be_header

    label = create(:label_with_drawings)
    expect(TemplateSection.new(label, label.drawings.pluck(:field_name).to_h_derived)).to be_label

    footer = create(:footer_with_drawings)
    expect(TemplateSection.new(footer, footer.drawings.pluck(:field_name).to_h_derived)).to be_footer
  end

  it "should have the correct number of formats" do
    expect(header_section.formats.count).to eq(header.drawings.count)
  end

  it "should have the correct number of drawings" do
    expect(header_section.drawings.count).to eq(header.drawings.count)
  end

  it "the formats and drawings should be of the correct type and have the correct attributes" do
    barcode = header.barcodes.first
    format = header_section.formats.find { |d| d.id == barcode.padded_placeholder_id }
    expect(format).to be_xb
    expect(format.x_origin).to eq(barcode.x_origin)
    expect(format.one_module_width).to eq(barcode.one_module_width)

    drawing = header_section.drawings.find { |d| d.id == barcode.padded_placeholder_id }
    expect(drawing).to be_rb
    expect(drawing.value).to eq(values[barcode.field_name])

    bitmap = header.bitmaps.first
    format = header_section.formats.find { |d| d.id == bitmap.padded_placeholder_id }
    expect(format).to be_pc
    expect(format.x_origin).to eq(bitmap.x_origin)
    expect(format.horizontal_magnification).to eq(bitmap.horizontal_magnification)

    drawing = header_section.drawings.find { |d| d.id == bitmap.padded_placeholder_id }
    expect(drawing).to be_rc
    expect(drawing.value).to eq(values[bitmap.field_name])

  end

  it "should have the correct list of commands" do
    expect(header_section.commands_list).to eq([:formats, "C", :drawings, "XS", "C"])
  end

end