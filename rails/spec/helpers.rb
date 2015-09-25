module Helpers
  def label_template_params
    ActionController::Parameters.new(
      label_template: {
        label_type_id: create(:label_type).id,
        header_attributes: header_attributes,
        label_attributes: label_attributes,
        footer_attributes: footer_attributes
      })
  end

  def label_template_params_with_invalid_label_type
    ActionController::Parameters.new(
      label_template: {
        header_attributes: header_attributes,
        label_attributes: label_attributes,
        footer_attributes: footer_attributes
      })
  end

  def label_template_params_with_invalid_association
     ActionController::Parameters.new(
      label_template: {
        label_type_id: create(:label_type).id,
        header_attributes: header_attributes,
        label_attributes: label_attributes,
        footer_attributes: invalid_footer_attributes
      })
  end

private

  def header_attributes
    {
      barcodes_attributes: [ attributes_for(:barcode), attributes_for(:barcode) ],
      bitmaps_attributes: [ attributes_for(:bitmap), attributes_for(:bitmap) ],
    }
  end

  def label_attributes
    {
      barcodes_attributes: [ attributes_for(:barcode), attributes_for(:barcode) ],
      bitmaps_attributes: [ attributes_for(:bitmap), attributes_for(:bitmap) ],
    }
  end

  def footer_attributes
    {
      barcodes_attributes: [ attributes_for(:barcode), attributes_for(:barcode) ],
      bitmaps_attributes: [ attributes_for(:bitmap), attributes_for(:bitmap) ],
    }
  end

  def invalid_footer_attributes
    {
      barcodes_attributes: [ attributes_for(:barcode), attributes_for(:barcode) ],
      bitmaps_attributes: [ attributes_for(:bitmap).except(:x_origin), attributes_for(:bitmap) ],
    }
  end



end