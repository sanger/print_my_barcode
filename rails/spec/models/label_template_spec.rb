require 'rails_helper'

RSpec.describe LabelTemplate, type: :model, helpers: true do

  it "should not be valid without a name" do
    expect(build(:label_template, name: nil)).to_not be_valid
  end

  it "should not be valid without a unique name" do
    label_template = create(:label_template)
    expect(build(:label_template, name: label_template.name)).to_not be_valid
  end

  it "should not be valid without a label_type" do
    expect(build(:label_template, label_type: nil)).to_not be_valid
  end

  it "should have a header, footer and label" do
    label_template = build(:label_template)
    expect(label_template.header).to_not be_nil
    expect(label_template.footer).to_not be_nil
    expect(label_template.label).to_not be_nil
    expect(label_template.sections.count).to eq(3)
  end

  context "permitted attributes" do

    let!(:params) { label_template_params }
    let(:permitted) { params.require(:label_template).permit(LabelTemplate.permitted_attributes)}

    it "label_type_id should be permitted" do
      expect(permitted[:label_type_id]).not_to be_nil
    end

    it "header_attributes should be permitted" do
      expect(permitted[:header_attributes]).not_to be_nil
    end

    it "label_attributes should be permitted" do
      expect(permitted[:label_attributes]).not_to be_nil
    end

    it "footer_attributes should be permitted" do
      expect(permitted[:footer_attributes]).not_to be_nil
    end

    it "barcodes_attributes should be permitted" do
      expect(permitted[:header_attributes][:barcodes_attributes]).not_to be_nil
    end

    it "bitmaps_attributes should be permitted" do
      expect(permitted[:label_attributes][:bitmaps_attributes]).not_to be_nil
    end

    it "bitmap attributes should be permitted" do
      bitmap = permitted[:label_attributes][:bitmaps_attributes].first
      expect(bitmap[:horizontal_magnification]).not_to be_nil
      expect(bitmap[:vertical_magnification]).not_to be_nil
      expect(bitmap[:font]).not_to be_nil
      expect(bitmap[:space_adjustment]).not_to be_nil
      expect(bitmap[:rotational_angles]).not_to be_nil
      expect(bitmap[:field_name]).not_to be_nil
      expect(bitmap[:x_origin]).not_to be_nil
      expect(bitmap[:y_origin]).not_to be_nil
    end

    it "barcode attributes should be permitted" do
      bitmap = permitted[:label_attributes][:barcodes_attributes].first
      expect(bitmap[:barcode_type]).not_to be_nil
      expect(bitmap[:one_module_width]).not_to be_nil
      expect(bitmap[:height]).not_to be_nil
      expect(bitmap[:field_name]).not_to be_nil
      expect(bitmap[:x_origin]).not_to be_nil
      expect(bitmap[:y_origin]).not_to be_nil
    end

  end

  
end
