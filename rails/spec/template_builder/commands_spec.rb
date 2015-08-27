require "rails_helper"

RSpec.describe "Commands", type: :model do |variable|
  
  context "Base" do

    let(:command) { Commands::Base.new }

    it "should have an appropriate prefix" do
      expect(command.prefix).to eq("PF")
    end

    it "should have appropriate control codes" do
      expect(command.control_codes).to eq("CC12345")
    end

    it "should produce some appropriate output text" do
      expect(command.output).to eq("PFCC12345")
      expect(command.output(';')).to eq("PF;CC12345")
    end

    it "should output the line" do
      expect(command.output_line).to eq("\u001bPFCC12345\n\u0000")
    end

    it "should produce an appropriate command" do
      expect(Commands::Base.command).to eq(command.output_line)
    end

    it "should respond to the appropriate prefix" do
      expect(command).to be_pf
      expect(command).to_not be_xs
    end
  end

  context "Set Label Size" do

    let(:command) { Commands::SetLabelSize.new(pitch_length: "0110", print_width: "0920", print_length: "0080") }

    it "should have an appropriate prefix" do
      expect(command.prefix).to eq("D")
      expect(command).to be_d
    end

    it "should have appropriate control codes" do
      expect(command.control_codes).to eq("0110,0920,0080")
    end
  end

  context "Adjust Position" do

    let(:command) { Commands::AdjustPosition.new(feed_value: "004") }

    it "should have an appropriate prefix" do
      expect(command.prefix).to eq("AX")
      expect(command).to be_ax
    end

    it "should have appropriate control codes" do
      expect(command.control_codes).to eq("+004,+000,+00")
    end

    it "should have an appropriate separator in the output" do
      expect(command.output_line).to include(";")

    end

  end

  context "Adjust Print Density" do

    let(:command) { Commands::AdjustPrintDensity.new(fine_adjustment: "08") }

    it "should have an appropriate prefix" do
      expect(command.prefix).to eq("AY")
      expect(command).to be_ay
    end

    it "should have appropriate control codes" do
      expect(command.control_codes).to eq("+08,0")
    end

    it "should have an appropriate separator in the output" do
      expect(command.output_line).to include(";")

    end

  end

  context "Feed" do

    let(:command) { Commands::Feed.new }

    it "should have an appropriate prefix" do
      expect(command.prefix).to eq("T")
      expect(command).to be_t
    end

    it "should have appropriate control codes" do
      expect(command.control_codes).to eq("20C32")
    end

  end

  context "Clear Image Buffer" do
    let(:command) { Commands::ClearImageBuffer.new }

    it "should produce some appropriate output text" do
      expect(command.output).to eq("C")
      expect(command).to be_c
    end
  end

  context "Format Bitmap" do

    let(:command) { Commands::BitmapFormat.new(id: "001", x_origin: "0020", y_origin: "0035")}
    let(:command_with_options) { Commands::BitmapFormat.new(id: "001", x_origin: "0020", y_origin: "0035", 
      horizontal_magnification: "05", vertical_magnification: "05", font: "B", space_adjustment: "12")}

    it "should have an appropriate prefix" do
      expect(command.prefix).to eq("PC")
      expect(command).to be_pc
    end

    it "should have appropriate control codes" do
      expect(command.control_codes).to eq("0020,0035,1,1,G,00,B")
      expect(command_with_options.control_codes).to eq("0020,0035,05,05,B,12,B")
    end

    it "should have the id in the output" do
      expect(command.output).to start_with("PC001;")
    end
  end

  context "Draw Bitmap" do

    let(:command) { Commands::BitmapDraw.new("001", "field_name")}

    it "should have an appropriate prefix" do
      expect(command.prefix).to eq("RC")
      expect(command).to be_rc
    end

    it "should produce some appropriate output" do
      expect(command.output).to eq("#{command.prefix}001;{{field_name}}")
    end

  end

  context "Format Barcode" do

    let(:command) { Commands::BarcodeFormat.new(id: "001", x_origin: "0300", y_origin: "0000")}
    let(:command_with_options) { Commands::BarcodeFormat.new(id: "001", x_origin: "0300", y_origin: "0000", 
      barcode_type: "9", one_module_width: "01", height: "0100")}

    it "should have an appropriate prefix" do
      expect(command.prefix).to eq("XB")
      expect(command).to be_xb
    end

    it "should have appropriate control codes" do
      expect(command.control_codes).to eq("0300,0000,5,3,02,0,0070,+0000000000,002,0,00")
      expect(command_with_options.control_codes).to eq("0300,0000,9,3,01,0,0100,+0000000000,002,0,00")
    end

    it "should have the id in the output" do
      expect(command.output).to start_with("XB001;")
    end
    
  end

  context "Draw Barcode" do

    let(:command) { Commands::BarcodeDraw.new("001", "field_name")}

    it "should have an appropriate prefix" do
      expect(command.prefix).to eq("RB")
      expect(command).to be_rb
    end

    it "should produce some appropriate output" do
      expect(command.output).to eq("#{command.prefix}001;{{field_name}}")
    end

  end

  context "issue" do

    let(:command) { Commands::Issue.new}

    it "should have an appropriate prefix" do
      expect(command.prefix).to eq("XS")
      expect(command).to be_xs
    end

    it "should have appropriate control codes" do
      expect(command.control_codes).to eq("I,0001,0002C3201")
    end

    it "should produce some appropriate output" do
      expect(command.output).to include(';')
    end
    
  end
end