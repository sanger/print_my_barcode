require "rails_helper"

RSpec.describe PrintJob, type: :model do 

  let!(:printer)            { create(:printer) }

  it "with a valid template builder should carry out the print job" do
    template = build(:template_builder)
    print_job = PrintJob::LPD.new(printer, template)
    allow(print_job).to receive(:system)
    expect(print_job.run).to be_truthy
  end

  it "with an invalid template builder should not carry out the print job" do
    template = build(:template_builder, values: {})
    print_job = PrintJob::LPD.new(printer, template)
    expect(template).to_not be_valid
    expect(print_job.run).to be_falsey
  end

  it "with a particular protocol should build a print job of the correct class" do
    template = build(:template_builder)
    print_job = PrintJob.build(printer, template)
    expect(print_job).to be_LPD
    print_job = PrintJob.build(create(:printer, protocol: "IPP"), template)
    expect(print_job).to be_IPP
  end


end