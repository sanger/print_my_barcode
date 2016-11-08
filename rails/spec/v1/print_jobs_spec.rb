require "rails_helper"

RSpec.describe V1::PrintJobsController, type: :request, helpers: true do

  let!(:printer)          { create(:printer) }
  let!(:label_template)   { create(:label_template) }

  it "should print a valid label" do
    allow_any_instance_of(LabelPrinter::PrintJob::LPD).to receive(:execute).and_return(true)
    post v1_print_jobs_path, {data: {attributes: { printer_name: printer.name, label_template_id: label_template.id, labels: label_template.dummy_labels.to_h}}}.to_json, {'ACCEPT' => "application/vnd.api+json", 'CONTENT_TYPE' => "application/vnd.api+json"}
    expect(response).to be_success
    expect(response).to have_http_status(:created)
    json = ActiveSupport::JSON.decode(response.body)["data"]
    json_attributes = json["attributes"]
    expect(json_attributes["printer_name"]).to eq(printer.name)
    expect(json_attributes["label_template_id"]).to eq(label_template.id)
    expect(json_attributes["labels"]).to eq(label_template.dummy_labels.to_h)
    expect(json["type"]).to eq("print_jobs")
  end

  it "should return an error if the label is not valid" do
    post v1_print_jobs_path, {data: {attributes: { label_template_id: label_template.id, labels: label_template.dummy_labels.to_h}}}.to_json, {'ACCEPT' => "application/vnd.api+json", 'CONTENT_TYPE' => "application/vnd.api+json"}
    expect(response).to have_http_status(:unprocessable_entity)

    json = ActiveSupport::JSON.decode(response.body)

    expect(json["errors"]).not_to be_empty
    expect(find_attribute_error_details(json, "printer")).to include("does not exist")
  end

  it "should return an error if request provides incorrect parameters" do
    post v1_print_jobs_path, {data: {attributes: { printer_name: printer.name, label_type_id: label_template.id, labels: label_template.dummy_labels.to_h}}}.to_json, {'ACCEPT' => "application/vnd.api+json", 'CONTENT_TYPE' => "application/vnd.api+json"}
    expect(response).to have_http_status(:unprocessable_entity)

    json = ActiveSupport::JSON.decode(response.body)

    expect(json["errors"]).not_to be_empty
    expect(find_attribute_error_details(json, "label_template")).to include("does not exist")
  end

end


