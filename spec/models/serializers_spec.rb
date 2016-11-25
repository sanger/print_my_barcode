require "rails_helper"

RSpec.describe "Serializers", type: :model do |variable|
  
  it "barcode should output the correct attributes" do
    barcode = create(:barcode)
    json = BarcodeSerializer.new(barcode).object
    expect(json.x_origin).to eq(barcode.x_origin)
    expect(json.y_origin).to eq(barcode.y_origin)
    expect(json.field_name).to eq(barcode.field_name)
    expect(json.barcode_type).to eq(barcode.barcode_type)
    expect(json.one_module_width).to eq(barcode.one_module_width)
    expect(json.height).to eq(barcode.height)
    expect(json.rotational_angle).to eq(barcode.rotational_angle)
    expect(json.one_cell_width).to eq(barcode.one_cell_width)
    expect(json.type_of_check_digit).to eq(barcode.type_of_check_digit)
    expect(json.no_of_columns).to eq(barcode.no_of_columns)
    expect(json.bar_height).to eq(barcode.bar_height)
  end

  it "bitmap should output the correct attributes" do
    bitmap = create(:bitmap)
    json = BitmapSerializer.new(bitmap).object
    expect(json.x_origin).to eq(bitmap.x_origin)
    expect(json.y_origin).to eq(bitmap.y_origin)
    expect(json.field_name).to eq(bitmap.field_name)
    expect(json.horizontal_magnification).to eq(bitmap.horizontal_magnification)
    expect(json.vertical_magnification).to eq(bitmap.vertical_magnification)
    expect(json.font).to eq(bitmap.font)
    expect(json.space_adjustment).to eq(bitmap.space_adjustment)
    expect(json.rotational_angles).to eq(bitmap.rotational_angles)
  end

  it "Print Job should output the correct attributes" do
    print_job = build(:print_job)
    json = PrintJobSerializer.new(print_job).object
    expect(json.printer_name).to eq(print_job.printer_name)
    expect(json.label_template_id).to eq(print_job.label_template_id)
    expect(json.labels).to eq(print_job.labels)
  end

  it "label should output the correct attributes" do
    label = create(:label_with_drawings)
    json = LabelSerializer.new(label).object
    expect(json.name).to eq(label.name)
    expect(json.barcodes.length).to eq(label.barcodes.count)
    expect(json.bitmaps.length).to eq(label.bitmaps.count)
  end
end