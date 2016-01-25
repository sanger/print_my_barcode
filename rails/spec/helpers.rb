module Helpers
  def label_template_params
    ActionController::Parameters.new(
      label_template: {
        name: build(:label_template).name,
        label_type_id: create(:label_type).id,
        labels_attributes: labels_attributes
      })
  end

  def label_template_params_with_invalid_label_type
    ActionController::Parameters.new(
      label_template: {
        name: build(:label_template).name,
        labels_attributes: labels_attributes
      })
  end

  def label_template_params_with_invalid_association
     ActionController::Parameters.new(
      label_template: {
        name: build(:label_template).name,
        label_type_id: create(:label_type).id,
        labels_attributes: labels_attributes.push(invalid_label_attributes)
      })
  end

private

  def labels_attributes
    [
      {
        name: build(:label).name,
        barcodes_attributes: [ attributes_for(:barcode), attributes_for(:barcode) ],
        bitmaps_attributes: [ attributes_for(:bitmap), attributes_for(:bitmap) ]
      },
      {
        name: build(:label).name,
        barcodes_attributes: [ attributes_for(:barcode), attributes_for(:barcode) ],
        bitmaps_attributes: [ attributes_for(:bitmap), attributes_for(:bitmap) ]
      }
    ]
  end

  def invalid_label_attributes
    {
      name: build(:label).name,
      barcodes_attributes: [ attributes_for(:barcode), attributes_for(:barcode) ],
      bitmaps_attributes: [ attributes_for(:bitmap).except(:x_origin), attributes_for(:bitmap) ],
    }
  end



end