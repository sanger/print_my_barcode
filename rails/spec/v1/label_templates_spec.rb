require "rails_helper"

RSpec.describe V1::LabelTemplatesController, type: :request, helpers: true do |variable|

  it "should allow retrieval of all label template" do
    label_templates = create_list(:label_template, 5)
    get v1_label_templates_path
    expect(response).to be_success
    expect(JSON.parse(response.body)["data"].length).to eq(label_templates.length)
  end

  it "filters by name" do
    label_templates = create_list(:label_template, 5)
    label_template  = label_templates.first

    get v1_label_templates_path, filter: { name: label_template.name }

    json = ActiveSupport::JSON.decode(response.body)

    expect(response).to be_success
    expect(json["data"].length).to eq(1)
    expect(json["data"][0]["id"]).to eq(label_template.id.to_s)
    expect(json["data"][0]["attributes"]["name"]).to eq(label_template.name)
  end

  it "should allow retrieval of information about a particular label template" do
    label_template = create(:label_template)
    get v1_label_template_path(label_template)
    expect(response).to be_success
    json = ActiveSupport::JSON.decode(response.body)
    json_attributes = json["data"]["attributes"]
    expect(json_attributes["name"]).to eq(label_template.name)

    json_label_type = json["included"].detect {|lt| lt["type"] == "label_types" }
    expect(json_label_type["attributes"]).to include(label_template.label_type.as_json.except("id"))

    expect(json["data"]["relationships"]["labels"]["data"].length).to eq(label_template.labels.count)
    label = json["included"].detect {|l| l["type"] == "labels" }
    expect(label["relationships"]["barcodes"]["data"].length).to eq(label_template.labels.find_by_name(label["attributes"]["name"]).barcodes.count)
    expect(label["relationships"]["bitmaps"]["data"].length).to eq(label_template.labels.find_by_name(label["attributes"]["name"]).bitmaps.count)
  end

  it "should allow creation of a new label template" do
    params = label_template_params
    expect {
      post v1_label_templates_path, params.to_json, {'ACCEPT' => "application/vnd.api+json", 'CONTENT_TYPE' => "application/vnd.api+json"}
      }.to change(LabelTemplate, :count).by(1)
    expect(response).to be_success
    expect(response).to have_http_status(:created)
    label_template = LabelTemplate.first

    expect(label_template.name).to eq(params[:data][:attributes][:name])
    expect(label_template.label_type_id).to eq(params[:data][:attributes][:label_type_id])
    expect(label_template.labels).to_not be_empty
    expect(label_template.labels.count).to eq(params[:data][:attributes][:labels_attributes].length)
    expect(label_template.labels.first.barcodes.count).to eq(params[:data][:attributes][:labels_attributes].first[:barcodes_attributes].length)
    expect(label_template.labels.first.bitmaps.count).to eq(params[:data][:attributes][:labels_attributes].first[:bitmaps_attributes].length)
  end

  it "should prevent creation of a new label template with invalid label type" do
    expect {
      post v1_label_templates_path, {data:{attributes:label_template_params_with_invalid_label_type}}.to_json, {'ACCEPT' => "application/vnd.api+json", 'CONTENT_TYPE' => "application/vnd.api+json"}
      }.to_not change(LabelTemplate, :count)
    expect(response).to have_http_status(:unprocessable_entity)

    json = ActiveSupport::JSON.decode(response.body)

    expect(json["errors"]).not_to be_empty

    label_type_errors = find_attribute_error_details(json, "label_type")
    expect(label_type_errors).to include("does not exist")
  end

  it "should prevent creation of a new label template with invalid association" do
    expect {
      post v1_label_templates_path, {data:{attributes:label_template_params_with_invalid_association}}.to_json, {'ACCEPT' => "application/vnd.api+json", 'CONTENT_TYPE' => "application/vnd.api+json"}
      }.to_not change(LabelTemplate, :count)
    expect(response).to have_http_status(:unprocessable_entity)

    json = ActiveSupport::JSON.decode(response.body)

    expect(json["errors"]).not_to be_empty

    x_origin_errors = find_attribute_error_details(json, "x_origin")

    expect(x_origin_errors.length).to eql(2)
    expect(x_origin_errors).to include("can't be blank")
    expect(x_origin_errors).to include("is invalid")

  end

  it "should allow update of existing label template" do
    label_template = create(:label_template)
    label_type = create(:label_type)
    patch v1_label_template_path(label_template), {data:{attributes: { label_type_id: label_type.id }}}.to_json, {'ACCEPT' => "application/vnd.api+json", 'CONTENT_TYPE' => "application/vnd.api+json"}
    expect(response).to be_success
    expect(ActiveSupport::JSON.decode(response.body)["data"]["relationships"]["label_type"]["data"]["id"].to_i).to eq(label_type.id)
  end

  it "should prevent update of existing label template with invalid attributes" do
    label_template = create(:label_template)
    patch v1_label_template_path(label_template), {data:{attributes:{ label_type_id: nil }}}.to_json, {'ACCEPT' => "application/vnd.api+json", 'CONTENT_TYPE' => "application/vnd.api+json"}
    expect(response).to have_http_status(:unprocessable_entity)

    json = ActiveSupport::JSON.decode(response.body)

    expect(json["errors"]).not_to be_empty

    label_type_errors = find_attribute_error_details(json, "label_type")
    expect(label_type_errors).to include("does not exist")
  end

end