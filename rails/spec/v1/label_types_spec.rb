require "rails_helper"

RSpec.describe V1::LabelTypesController, type: :request do |variable|

  it "should allow retrieval of all label types" do
    label_types = create_list(:label_type, 5)
    get v1_label_types_path
    expect(response).to be_success
    expect(ActiveSupport::JSON.decode(response.body)["label_types"].length).to eq(label_types.length)
  end

  it "should allow retrieval of information about a particular label type" do
    label_type = create(:label_type)
    get v1_label_type_path(label_type)
    expect(response).to be_success
    json = ActiveSupport::JSON.decode(response.body)["label_type"]
    expect(json["id"]).to eq(label_type.id)
    expect(json["feed_value"]).to eq(label_type.feed_value)
    expect(json["fine_adjustment"]).to eq(label_type.fine_adjustment)
    expect(json["pitch_length"]).to eq(label_type.pitch_length)
    expect(json["print_width"]).to eq(label_type.print_width)
    expect(json["print_length"]).to eq(label_type.print_length)
    expect(json["name"]).to eq(label_type.name)

  end

  it "should allow creation of a new label type" do
    expect {
      post v1_label_types_path, label_type: attributes_for(:label_type)
      }.to change(LabelType, :count).by(1)
    expect(response).to be_success
  end

  it "should prevent creation of a new label type with invalid attributes" do
     expect {
      post v1_label_types_path, label_type: attributes_for(:label_type).except(:name)
      }.to_not change(LabelType, :count)
    expect(response).to have_http_status(:unprocessable_entity)
    expect(ActiveSupport::JSON.decode(response.body)["errors"]).not_to be_empty
  end

  it "should allow update of existing label type" do
    label_type = create(:label_type)
    new_name = build(:label_type).name
    patch v1_label_type_path(label_type), label_type: { name: new_name }
    expect(response).to be_success
    expect(ActiveSupport::JSON.decode(response.body)["label_type"]["name"]).to eq(new_name)
  end

  it "should prevent update of existing label type with invalid attributes" do
    label_type = create(:label_type)
    patch v1_label_type_path(label_type), label_type: { name: nil }
    expect(response).to have_http_status(:unprocessable_entity)
    expect(ActiveSupport::JSON.decode(response.body)["errors"]).not_to be_empty
  end

end