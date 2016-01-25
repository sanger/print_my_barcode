require "rails_helper"

RSpec.describe V1::PrintJobsController, type: :request do

  let!(:printer)          { create(:printer) }
  let!(:label_template)   { create(:label_template) }

  it "should print a valid label" do
    allow_any_instance_of(LabelPrinter::PrintJob::LPD).to receive(:execute).and_return(true)
    post v1_print_jobs_path, print_job: { printer_name: printer.name, label_template_id: label_template.id, data: label_template.dummy_values.to_h }
    expect(response).to be_success
    json = ActiveSupport::JSON.decode(response.body)
    expect(json["printer_name"]).to eq(printer.name)
    expect(json["label_template_id"]).to eq(label_template.id.to_s)
    expect(json["data"]).to eq(label_template.dummy_values.to_h)
  end

  it "should return an error if the label is not valid" do
    post v1_print_jobs_path, print_job: { label_template_id: label_template.id, data: label_template.dummy_values.to_h }
    expect(response).to have_http_status(:unprocessable_entity)
    expect(ActiveSupport::JSON.decode(response.body)["errors"]).not_to be_empty
  end

end