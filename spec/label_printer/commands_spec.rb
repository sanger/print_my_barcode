require "rails_helper"

RSpec.describe LabelPrinter::Commands, type: :model do
  
  context "Base" do

    let(:command) { LabelPrinter::Commands::Base.new }

    it "should have an appropriate prefix" do
      expect(command.prefix).to eq("PF")
    end

    it "should have appropriate control codes" do
      expect(command.control_codes).to eq("CC12345")
    end

    it "should produce some appropriate formatted text" do
      expect(command.formatted).to eq("PFCC12345")
      expect(command.formatted(';')).to eq("PF;CC12345")
    end

    it "should output the line" do
      expect(command.to_s).to eq("\u001bPFCC12345\n\u0000")
    end

    it "should produce an appropriate command" do
      expect(LabelPrinter::Commands::Base.command).to eq(command.to_s)
    end

    it "should respond to the appropriate prefix" do
      expect(command).to be_pf
      expect(command).to_not be_xs
    end
  end

  context "Set Label Size" do

    let(:command) { LabelPrinter::Commands::SetLabelSize.new(pitch_length: "0110", print_width: "0920", print_length: "0080") }

    it "should have an appropriate prefix" do
      expect(command.prefix).to eq("D")
      expect(command).to be_d
    end

    it "should have appropriate control codes" do
      expect(command.control_codes).to eq("0110,0920,0080")
    end
  end

  context "Adjust Position" do

    let(:command) { LabelPrinter::Commands::AdjustPosition.new(feed_value: "004") }

    it "should have an appropriate prefix" do
      expect(command.prefix).to eq("AX")
      expect(command).to be_ax
    end

    it "should have appropriate control codes" do
      expect(command.control_codes).to eq("+004,+000,+00")
    end

    it "should have an appropriate separator in the output" do
      expect(command.to_s).to include(";")

    end

  end

  context "Adjust Print Density" do

    let(:command) { LabelPrinter::Commands::AdjustPrintDensity.new(fine_adjustment: "08") }

    it "should have an appropriate prefix" do
      expect(command.prefix).to eq("AY")
      expect(command).to be_ay
    end

    it "should have appropriate control codes" do
      expect(command.control_codes).to eq("+08,0")
    end

    it "should have an appropriate separator in the output" do
      expect(command.to_s).to include(";")

    end

  end

  context "Feed" do

    let(:command) { LabelPrinter::Commands::Feed.new }

    it "should have an appropriate prefix" do
      expect(command.prefix).to eq("T")
      expect(command).to be_t
    end

    it "should have appropriate control codes" do
      expect(command.control_codes).to eq("20C32")
    end

  end

  context "Clear Image Buffer" do
    let(:command) { LabelPrinter::Commands::ClearImageBuffer.new }

    it "should produce some appropriate output text" do
      expect(command.formatted).to eq("C")
      expect(command).to be_c
    end
  end

  context "Format Bitmap" do

    let(:command) { LabelPrinter::Commands::BitmapFormat.new(id: "001", x_origin: "0020", y_origin: "0035")}
    let(:command_with_options) { LabelPrinter::Commands::BitmapFormat.new(id: "001", x_origin: "0020", y_origin: "0035", 
      horizontal_magnification: "05", vertical_magnification: "05", font: "B", space_adjustment: "12", rotational_angles: "11")}

    it "should have an appropriate prefix" do
      expect(command.prefix).to eq("PC")
      expect(command).to be_pc
    end

    it "should have appropriate control codes" do
      expect(command.control_codes).to eq("0020,0035,1,1,G,+00,00,B")
      expect(command_with_options.control_codes).to eq("0020,0035,05,05,B,+12,11,B")
    end

    it "should have the id in the formatting" do
      expect(command.formatted).to start_with("PC001;")
    end
  end

  context "Draw Bitmap" do

    let(:command) { LabelPrinter::Commands::BitmapDraw.new("001", "a_value")}

    it "should have an appropriate prefix" do
      expect(command.prefix).to eq("RC")
      expect(command).to be_rc
    end

    it "should produce some appropriate formatting" do
      expect(command.formatted).to eq("#{command.prefix}001;a_value")
    end

  end

  context "Format Barcode" do

    let(:command) { LabelPrinter::Commands::BarcodeFormat.new(id: "001", x_origin: "0300", y_origin: "0000")}

    it "should have an appropriate prefix" do
      expect(command.prefix).to eq("XB")
      expect(command).to be_xb
    end

    it "should have appropriate control codes" do
      expect(command.control_codes).to eq("0300,0000,5,3,02,0,0070,+0000000000,002,0,00")
    end

    it "should have the id in the formatting" do
      expect(command.formatted).to start_with("XB001;")
    end

    context "1D" do

      let(:command) { LabelPrinter::Commands::BarcodeFormat.new(id: "001", x_origin: "0300", y_origin: "0000", 
        barcode_type: "9", type_of_check_digit: "2", one_module_width: "01", height: "0100")}

      it "should have appropriate control codes" do
        expect(command.control_codes).to eq("0300,0000,9,2,01,0,0100,+0000000000,002,0,00")
      end
    end

    context "2D" do
      let(:command) { LabelPrinter::Commands::BarcodeFormat.new(id: "001", x_origin: "0300", y_origin: "0000", 
        barcode_type: "Q", one_cell_width: "50", rotational_angle: "3")}

      it "should have appropriate control codes" do
        expect(command.control_codes).to eq("0300,0000,Q,20,50,05,3")
      end
    end

    context "PDF417" do
       let(:command) { LabelPrinter::Commands::BarcodeFormat.new(id: "001", x_origin: "0300", y_origin: "0000", 
          barcode_type: "P", one_module_width: "01", no_of_columns: "10", bar_height: "0100")}

      it "should have appropriate control codes" do
        expect(command.control_codes).to eq("0300,0000,P,00,01,10,0,0100")
      end
    end

  end

  context "Draw Barcode" do

    let(:command) { LabelPrinter::Commands::BarcodeDraw.new("001", "a_value")}

    it "should have an appropriate prefix" do
      expect(command.prefix).to eq("RB")
      expect(command).to be_rb
    end

    it "should produce some appropriate formatting" do
      expect(command.formatted).to eq("#{command.prefix}001;a_value")
    end

  end

  context "Issue" do

    let(:command) { LabelPrinter::Commands::Issue.new}

    it "should have an appropriate prefix" do
      expect(command.prefix).to eq("XS")
      expect(command).to be_xs
    end

    it "should have appropriate control codes" do
      expect(command.control_codes).to eq("I,0001,0002C3201")
    end

    it "should produce some appropriate output" do
      expect(command.to_s).to include(';')
    end
    
  end

  context LabelPrinter::Commands::Outputter do

    class MyCommands
      include LabelPrinter::Commands::Outputter

      attr_reader :nil_command

      set_commands_list :set_label_size, "C", "T", "XS", :nil_command, :array_of_commands, :hash_of_commands

      def set_label_size
        LabelPrinter::Commands::SetLabelSize.new(pitch_length: "1234",print_width: "5678",print_length: "9012")
      end

      def array_of_commands
        [
          LabelPrinter::Commands::AdjustPosition.new(feed_value: "25"),
          LabelPrinter::Commands::BarcodeDraw.new("123", "ABC"),
          LabelPrinter::Commands::AdjustPrintDensity.new(fine_adjustment: "4")
        ]
      end

       def hash_of_commands
        {
          a: LabelPrinter::Commands::AdjustPosition.new(feed_value: "100"),
          b: LabelPrinter::Commands::BarcodeDraw.new("123", "CDE"),
          c: LabelPrinter::Commands::AdjustPrintDensity.new(fine_adjustment: "5")
        }
      end
    end

    subject { MyCommands.new}

    it "should have the correct list of commands" do
      expect(subject.commands_list).to eq([:set_label_size, "C", "T", "XS", :nil_command, :array_of_commands, :hash_of_commands])
    end

    it "should have the correct commands" do
      commands = subject.commands
      expect(commands.count).to eq(11)
      expect(commands.first).to be_d
      expect(commands[1]).to be_c
      expect(commands[2]).to be_t
      expect(commands[3]).to be_xs
      expect(commands[4]).to be_nil
      expect(commands[5]).to be_ax
      expect(commands[6]).to be_rb
      expect(commands[7]).to be_ay
      expect(commands[8]).to be_ax
      expect(commands[9]).to be_rb
      expect(commands.last).to be_ay
    end

    it "should have the correct output" do
      output = LabelPrinter::Commands::SetLabelSize.command(pitch_length: "1234",print_width: "5678",print_length: "9012") <<
      LabelPrinter::Commands::ClearImageBuffer.command <<
      LabelPrinter::Commands::Feed.command <<
      LabelPrinter::Commands::Issue.command <<
      LabelPrinter::Commands::AdjustPosition.command(feed_value: "25") <<
      LabelPrinter::Commands::BarcodeDraw.command("123", "ABC") <<
      LabelPrinter::Commands::AdjustPrintDensity.command(fine_adjustment: "4") <<
      LabelPrinter::Commands::AdjustPosition.command(feed_value: "100") <<
      LabelPrinter::Commands::BarcodeDraw.command("123", "CDE") <<
      LabelPrinter::Commands::AdjustPrintDensity.command(fine_adjustment: "5")
      expect(subject.to_s).to eq(output)
    end
  end

end