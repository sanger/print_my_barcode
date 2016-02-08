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

    expect(json["labels"].length).to eq(label_template.labels.count)
    label = json["labels"].first
    expect(label["barcodes"].length).to eq(label_template.labels.find_by_name(label["name"]).barcodes.count)
    expect(label["bitmaps"].length).to eq(label_template.labels.find_by_name(label["name"]).barcodes.count)

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
    expect(label_template.labels).to_not be_empty
    expect(label_template.labels.count).to eq(params[:label_template][:labels_attributes].length)
    expect(label_template.labels.first.barcodes.count).to eq(params[:label_template][:labels_attributes].first[:barcodes_attributes].length)
    expect(label_template.labels.first.bitmaps.count).to eq(params[:label_template][:labels_attributes].first[:bitmaps_attributes].length)
  end

  it "should prevent creation of a new label template with invalid label type" do
    expect {
      post v1_label_templates_path, label_template_params_with_invalid_label_type
      }.to_not change(LabelTemplate, :count)
    expect(response).to have_http_status(:unprocessable_entity)
    expect(ActiveSupport::JSON.decode(response.body)["errors"]).not_to be_empty
  end

  it "should prevent creation of a new label template with invalid association" do
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

end