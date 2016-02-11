require "rails_helper"

RSpec.describe V1::PrintersController, type: :request do |variable|

  it "should allow retrieval of all printers" do
    printers = create_list(:printer, 5)
    get v1_printers_path
    expect(response).to be_success
    expect(ActiveSupport::JSON.decode(response.body)["printers"].length).to eq(printers.length)
  end

  it "should allow retrieval of information about a particular printer" do
    printer = create(:printer)
    get v1_printer_path(printer)
    expect(response).to be_success
    json = ActiveSupport::JSON.decode(response.body)["printer"]
    expect(json["id"]).to eq(printer.id)
    expect(json["name"]).to eq(printer.name)
  end

  it "should allow creation of a new printer" do
    expect {
      post v1_printers_path, printer: attributes_for(:printer)
      }.to change(Printer, :count).by(1)
    expect(response).to be_success
  end

  it "should prevent creation of a new printer with invalid attributes" do
     expect {
      post v1_printers_path, printer: {name: nil}
      }.to_not change(Printer, :count)
    expect(response).to have_http_status(:unprocessable_entity)
    expect(ActiveSupport::JSON.decode(response.body)["errors"]).not_to be_empty
  end

end