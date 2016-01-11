require "rails_helper"

RSpec.describe V1::LabelTemplatesController, type: :request, helpers: true do |variable|
  
  it "should allow retrieval of all label template" do
    label_templates = create_list(:label_template, 5)
    get v1_label_templates_path
    expect(response).to be_success
    expect(JSON.parse(response.body)["label_templates"].length).to eq(label_templates.length)
  end

  it "should allow retrieval of information about a particular label template" do
    label_template = create(:label_template)
    get v1_label_template_path(label_template)
    expect(response).to be_success
    json = ActiveSupport::JSON.decode(response.body)["label_template"]
    expect(json["label_type"]).to eq(label_template.label_type.as_json)
    expect(json["name"]).to eq(label_template.name)

    expect(json["header"].length).to eq(2)
    expect(json["label"].length).to eq(2)
    expect(json["footer"].length).to eq(2)

    expect(json["header"]["barcodes"].length).to eq(label_template.header.barcodes.count)
    expect(json["header"]["bitmaps"].length).to eq(label_template.header.barcodes.count)

  end

  it "should allow creation of a new label template" do
    params = label_template_params
    expect {
      post v1_label_templates_path, params
      }.to change(LabelTemplate, :count).by(1)
    expect(response).to be_success
    label_template = LabelTemplate.first
    expect(label_template.name).to eq(params[:label_template][:name])
    expect(label_template.label_type_id).to eq(params[:label_template][:label_type_id])
    expect(label_template.header).to_not be_nil
    expect(label_template.label).to_not be_nil
    expect(label_template.footer).to_not be_nil
    expect(label_template.header.barcodes.count).to eq(params[:label_template][:header_attributes][:barcodes_attributes].length)
    expect(label_template.footer.bitmaps.count).to eq(params[:label_template][:footer_attributes][:bitmaps_attributes].length)
  end

  it "should prevent creation of a new label template with invalid attributes" do
    expect {
      post v1_label_templates_path, label_template_params_with_invalid_label_type
      }.to_not change(LabelTemplate, :count)
    expect(response).to have_http_status(:unprocessable_entity)
    expect(ActiveSupport::JSON.decode(response.body)["errors"]).not_to be_empty

    expect {
      post v1_label_templates_path, label_template_params_with_invalid_association
      }.to_not change(LabelTemplate, :count)
    expect(response).to have_http_status(:unprocessable_entity)
    expect(ActiveSupport::JSON.decode(response.body)["errors"]).not_to be_empty
  end

  it "should allow update of existing label template" do
    label_template = create(:label_template)
    label_type = create(:label_type)
    patch v1_label_template_path(label_template), label_template: { label_type_id: label_type.id }
    expect(response).to be_success
    expect(ActiveSupport::JSON.decode(response.body)["label_template"]["label_type"]["id"]).to eq(label_type.id)
  end

  it "should prevent update of existing label template with invalid attributes" do
    label_template = create(:label_template)
    patch v1_label_template_path(label_template), label_template: { label_type_id: nil }
    expect(response).to have_http_status(:unprocessable_entity)
    expect(ActiveSupport::JSON.decode(response.body)["errors"]).not_to be_empty
  end

  it "should print a label template with values" do
    label_template = create(:label_template)
    post print_v1_label_template_path(label_template), print: label_template.field_names.dummy_values
    expect(response).to be_success
    json = ActiveSupport::JSON.decode(response.body)
    expect(json["header"]).to eq(label_template.field_names.dummy_values[:header])
    expect(json["label"]).to eq(label_template.field_names.dummy_values[:label])
    expect(json["footer"]).to eq(label_template.field_names.dummy_values[:footer])

    post print_v1_label_template_path(label_template), print: label_template.field_names.dummy_values.except(:header)
    expect(response).to be_success
    json = ActiveSupport::JSON.decode(response.body)
    expect(json["header"]).to be_nil
    expect(json["label"]).to eq(label_template.field_names.dummy_values[:label])
    expect(json["footer"]).to eq(label_template.field_names.dummy_values[:footer])
  end
end