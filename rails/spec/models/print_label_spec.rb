require "rails_helper"

RSpec.describe PrintLabel, type: :model do

  let!(:printer)        { create(:printer) }
  let!(:label_template) { create(:label_template) }

  it "should have a printer" do
    expect(build(:print_label, printer_name: printer.name)).to be_valid
    expect(build(:print_label, printer_name: nil)).to_not be_valid
    expect(build(:print_label, printer_name: 999)).to_not be_valid
  end

  it "should have a label template" do
    expect(build(:print_label, label_template_id: label_template.id, values: label_template.field_names.dummy_values)).to be_valid
    expect(build(:print_label, label_template_id: nil)).to_not be_valid
    expect(build(:print_label, label_template_id: 999)).to_not be_valid
  end

  it "should have some values" do
    expect(build(:print_label, label_template_id: label_template.id, values: label_template.field_names.dummy_values)).to be_valid
    expect(build(:print_label, values: nil)).to_not be_valid
    expect(build(:print_label, values: {labels: [{ "label_1": "some text"}]})).to_not be_valid
  end

  it "should print the label if it is valid" do
    print_label = build(:print_label)
    print_job = PrintJob.build(print_label.printer, build(:template_builder))
    allow(print_job).to receive(:run).and_return(true)
    allow(print_label).to receive(:print_job).and_return(print_job)
    expect(print_label.run).to be_truthy
  end

  it "should not print the label if it is not valid" do
    print_label = build(:print_label)
    print_job = PrintJob.build(print_label.printer, build(:template_builder))
    allow(print_job).to receive(:run).and_return(false)
    allow(print_label).to receive(:print_job).and_return(print_job)
    expect(print_label.run).to be_falsey
  end
  
end