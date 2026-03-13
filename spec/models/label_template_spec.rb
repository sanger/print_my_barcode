# frozen_string_literal: true

require 'rails_helper'

RSpec.describe LabelTemplate, :helpers, type: :model do
  let!(:label_type) { create(:label_type) }

  it 'is not valid without a name' do
    expect(build(:label_template, name: nil)).not_to be_valid
  end

  it 'is not valid without a unique name' do
    label_template = create(:label_template)
    expect(build(:label_template, name: label_template.name)).not_to be_valid
  end

  context 'label type' do
    it 'is valid if it exists' do
      expect(build(:label_template, label_type_id: label_type.id)).to be_valid
    end

    it 'is not valid if it is blank' do
      expect(build(:label_template, label_type: nil)).not_to be_valid
    end

    it 'is not valid if label type id is not a valid label type' do
      expect(build(:label_template, label_type_id: 100)).not_to be_valid
    end
  end

  it 'is not valid unless label is valid' do
    expect(build(:label_template, labels_attributes: [invalid_label_attributes])).not_to be_valid
  end

  it 'has labels' do
    label_template = build(:label_template)
    expect(label_template.labels).not_to be_empty
  end

  it 'is able to extract field names' do
    label_template = create(:label_template)
    label_template.labels.each do |label|
      expect(label_template.field_names[label.name]).to eq(label.field_names)
    end
  end

  context 'permitted attributes' do
    let!(:params) { label_template_params }
    let(:permitted) { params.require(:data).require(:attributes).permit(LabelTemplate.permitted_attributes) }

    it 'label_type_id should be permitted' do
      expect(permitted[:label_type_id]).not_to be_nil
    end

    it 'label_attributes should be permitted' do
      expect(permitted[:labels_attributes]).not_to be_nil
    end

    it 'barcodes_attributes should be permitted' do
      expect(permitted[:labels_attributes].first[:barcodes_attributes]).not_to be_nil
    end

    it 'bitmaps_attributes should be permitted' do
      expect(permitted[:labels_attributes].first[:bitmaps_attributes]).not_to be_nil
    end

    it 'bitmap attributes should be permitted' do
      bitmap = permitted[:labels_attributes].first[:bitmaps_attributes].first
      expect(bitmap[:horizontal_magnification]).not_to be_nil
      expect(bitmap[:vertical_magnification]).not_to be_nil
      expect(bitmap[:font]).not_to be_nil
      expect(bitmap[:space_adjustment]).not_to be_nil
      expect(bitmap[:rotational_angles]).not_to be_nil
      expect(bitmap[:field_name]).not_to be_nil
      expect(bitmap[:x_origin]).not_to be_nil
      expect(bitmap[:y_origin]).not_to be_nil
    end

    it 'barcode attributes should be permitted' do
      bitmap = permitted[:labels_attributes].first[:barcodes_attributes].first
      expect(bitmap[:barcode_type]).not_to be_nil
      expect(bitmap[:one_module_width]).not_to be_nil
      expect(bitmap[:height]).not_to be_nil
      expect(bitmap[:field_name]).not_to be_nil
      expect(bitmap[:x_origin]).not_to be_nil
      expect(bitmap[:y_origin]).not_to be_nil
    end
  end

  it 'destroys associated records' do
    label_template = create(:label_template)
    label_ids = label_template.labels.pluck(:id)
    label_template.destroy
    label_ids.each do |label_id|
      expect(Label.find_by(id: label_id)).to be_nil
    end
  end

  it 'dups a label correctly' do
    label_template = create(:label_template)
    label_template_dup = label_template.super_dup
    expect(label_template_dup.name).to eq("#{label_template.name} copy")
    expect(label_template_dup.label_type).to eq(label_template.label_type)
    expect(label_template_dup.labels.count).to eq(label_template.labels.count)
    label_template_dup_label_ids = label_template_dup.labels.pluck(:id)
    label_template.labels.pluck(:id).each do |id|
      expect(label_template_dup_label_ids).not_to include(id)
    end
    label_template_dup = label_template.super_dup('A new label template')
    expect(label_template_dup.name).to eq('A new label template')
  end
end
