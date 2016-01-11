require "rails_helper"

RSpec.describe V1::PrintLabelsController, type: :request do

  let!(:printer)          { create(:printer) }
  let!(:label_template)   { create(:label_template) }

  it "should print a valid label" do
    allow_any_instance_of(PrintLabel).to receive(:run).and_return(true)
    post v1_print_labels_path, print_label: { printer_name: printer.name, label_template_id: label_template.id, values: label_template.field_names.dummy_values }
    expect(response).to be_success
    json = ActiveSupport::JSON.decode(response.body)["print_label"]
    expect(json["printer_name"]).to eq(printer.name)
    expect(json["label_template_id"]).to eq(label_template.id.to_s)
    expect(json["values"]).to eq(label_template.field_names.dummy_values)
  end

  it "should return an error if the label is not valid" do
    post v1_print_labels_path, print_label: { label_template_id: label_template.id, values: label_template.field_names.dummy_values }
    expect(response).to have_http_status(:unprocessable_entity)
    expect(ActiveSupport::JSON.decode(response.body)["errors"]).not_to be_empty
  end

end