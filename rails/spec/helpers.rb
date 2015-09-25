module Helpers
  def label_template_params
    ActionController::Parameters.new(
      label_template: {
        label_type_id: create(:label_type).id,
        header_attributes: {
          barcodes_attributes: [ attributes_for(:barcode), attributes_for(:barcode) ],
          bitmaps_attributes: [ attributes_for(:bitmap), attributes_for(:bitmap) ],
        },
        label_attributes: {
          barcodes_attributes: [ attributes_for(:barcode), attributes_for(:barcode) ],
          bitmaps_attributes: [ attributes_for(:bitmap), attributes_for(:bitmap) ],
        },
        footer_attributes: {
          barcodes_attributes: [ attributes_for(:barcode), attributes_for(:barcode) ],
          bitmaps_attributes: [ attributes_for(:bitmap), attributes_for(:bitmap) ],
        }
      })
  end

  def label_template_params_with_invalid_label_type
    ActionController::Parameters.new(
      label_template: {
        header_attributes: {
          barcodes_attributes: [ attributes_for(:barcode), attributes_for(:barcode) ],
          bitmaps_attributes: [ attributes_for(:bitmap), attributes_for(:bitmap) ],
        },
        label_attributes: {
          barcodes_attributes: [ attributes_for(:barcode), attributes_for(:barcode) ],
          bitmaps_attributes: [ attributes_for(:bitmap), attributes_for(:bitmap) ],
        },
        footer_attributes: {
          barcodes_attributes: [ attributes_for(:barcode), attributes_for(:barcode) ],
          bitmaps_attributes: [ attributes_for(:bitmap), attributes_for(:bitmap) ],
        }
      })
  end

  def label_template_params_with_invalid_association
     ActionController::Parameters.new(
      label_template: {
        label_type_id: create(:label_type).id,
        header_attributes: {
          barcodes_attributes: [ attributes_for(:barcode), attributes_for(:barcode) ],
          bitmaps_attributes: [ attributes_for(:bitmap), attributes_for(:bitmap) ],
        },
        label_attributes: {
          barcodes_attributes: [ attributes_for(:barcode), attributes_for(:barcode) ],
          bitmaps_attributes: [ attributes_for(:bitmap), attributes_for(:bitmap) ],
        },
        footer_attributes: {
          barcodes_attributes: [ attributes_for(:barcode), attributes_for(:barcode) ],
          bitmaps_attributes: [ attributes_for(:bitmap).except(:x_origin), attributes_for(:bitmap) ],
        }
      })
  end

private 



end