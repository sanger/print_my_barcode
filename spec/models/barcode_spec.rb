# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Barcode, type: :model do
  it 'validates form of barcode type' do
    expect(build(:barcode, barcode_type: '1')).to be_valid
    expect(build(:barcode, barcode_type: '10')).not_to be_valid
    expect(build(:barcode, barcode_type: 'X')).to be_valid
    expect(build(:barcode, barcode_type: 'XX')).not_to be_valid
  end

  it 'validates format of one_module_width' do
    expect(build(:barcode, one_module_width: 'XX')).not_to be_valid
  end

  it 'validates format of height' do
    expect(build(:barcode, height: '111')).not_to be_valid
    expect(build(:barcode, height: '111X')).not_to be_valid
  end

  it 'validates format of rotational angles' do
    expect(build(:barcode, rotational_angle: '111')).not_to be_valid
    expect(build(:barcode, rotational_angle: 'XXX')).not_to be_valid
  end

  it 'validates format of one cell width' do
    expect(build(:barcode, one_module_width: 'XX')).not_to be_valid
  end

  it 'validates format of type of check digit' do
    expect(build(:barcode, type_of_check_digit: 'X')).not_to be_valid
    expect(build(:barcode, type_of_check_digit: '22')).not_to be_valid
  end

  it 'validates format of number of columns' do
    expect(build(:barcode, no_of_columns: '1')).not_to be_valid
    expect(build(:barcode, no_of_columns: 'X')).not_to be_valid
    expect(build(:barcode, no_of_columns: '333')).not_to be_valid
  end

  it 'validates format of bar height' do
    expect(build(:barcode, bar_height: '111')).not_to be_valid
    expect(build(:barcode, bar_height: 'XXX')).not_to be_valid
    expect(build(:barcode, bar_height: '11111')).not_to be_valid
  end

  it 'validates format of narrow bar width' do
    expect(build(:barcode, narrow_bar_width: '01')).to be_valid
    expect(build(:barcode, narrow_bar_width: 'XX')).not_to be_valid
    expect(build(:barcode, narrow_bar_width: '111')).not_to be_valid
  end

  it 'validates format of narrow space width' do
    expect(build(:barcode, narrow_space_width: '01')).to be_valid
    expect(build(:barcode, narrow_space_width: 'XX')).not_to be_valid
    expect(build(:barcode, narrow_space_width: '111')).not_to be_valid
  end

  it 'validates format of wide bar width' do
    expect(build(:barcode, wide_bar_width: '01')).to be_valid
    expect(build(:barcode, wide_bar_width: 'XX')).not_to be_valid
    expect(build(:barcode, wide_bar_width: '111')).not_to be_valid
  end

  it 'validates format of wide space width' do
    expect(build(:barcode, wide_space_width: '01')).to be_valid
    expect(build(:barcode, wide_space_width: 'XX')).not_to be_valid
    expect(build(:barcode, wide_space_width: '111')).not_to be_valid
  end

  it 'validates format of char to char space width' do
    expect(build(:barcode, char_to_char_space_width: '01')).to be_valid
    expect(build(:barcode, char_to_char_space_width: 'XX')).not_to be_valid
    expect(build(:barcode, char_to_char_space_width: '111')).not_to be_valid
  end

  it 'assigns a placeholder id if there is a section' do
    label = create(:label)

    create_list(:bitmap, 2, label:)
    expect(create(:barcode, label:).placeholder_id).to eq(1)
    expect(create(:barcode, label:).placeholder_id).to eq(2)
  end

  it 'pads the placeholder_id' do
    expect(build(:barcode, placeholder_id: 1).padded_placeholder_id).to eq('01')
  end

  it 'template_attributes should contain the correct attributes' do
    barcode = create(:barcode)
    expect(barcode.template_attributes).to eq(barcode.options.merge(id: barcode.padded_placeholder_id, x_origin: barcode.x_origin, y_origin: barcode.y_origin))
  end

  it 'returns true for barcode?' do
    expect(build(:barcode).barcode?).to be_truthy
  end

  it 'returns false for bitmap?' do
    expect(build(:barcode).bitmap?).to be_falsey
  end
end
