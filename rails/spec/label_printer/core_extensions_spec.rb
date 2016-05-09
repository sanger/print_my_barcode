require "rails_helper"

RSpec.describe LabelPrinter::CoreExtensions, type: :model do

  it "#to_hex should convert numbers to the correct hexadecimal number" do
    expect(1.to_hex).to eq("0x01")
    expect(1.to_hex(8)).to eq("0x00000001")
    expect(26.to_hex).to eq("0x1A")
    expect(45.to_hex).to eq("0x2D")
    expect(145.to_hex).to eq("0x91")
    expect(1.1.to_hex).to eq("0x0101")
    expect(1.0.to_hex).to eq("0x0100")
  end

end