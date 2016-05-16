require "rails_helper"

RSpec.describe LabelPrinter::DataInput, type: :model do

  let!(:label_template) { create(:label_template)}

  context "List" do

    let(:my_list)       { LabelPrinter::DataInput::List.new do |list|
                            list.add("a", "one")
                                .add("b", "two")
                                .add("c", "three")
                                .add("c", "four")
                                .add("c", "five")
                          end
                        }

      let(:other_list)  { LabelPrinter::DataInput::List.new do |list|
                            list.add("c", "six")
                                .add("d", "seven")
                                .add("e", "eight")
                          end
                        }

    it "should have the correct number of items" do
      expect(my_list.count).to eq(5)
    end

    it "should label each item correctly" do
      expect(my_list.find("a")).to eq("one")
      expect(my_list.find("b")).to eq("two")
      expect(my_list.find("c")).to eq({"c_1" => "three", "c_2" => "four", "c_3" => "five"})
      expect(my_list.find_by("c")).to eq("three")
    end

    it "should be able to append another array and not lose any keys" do
      my_list.append(other_list)
      expect(my_list.count).to eq(8)
      expect(my_list.find("d")).to eq("seven")
      expect(my_list.find("e")).to eq("eight")
      expect(my_list.find("c")).to eq({"c_1" => "three", "c_2" => "four", "c_3" => "five", "c_4" => "six"})
    end
  end

  context "Label" do

    let!(:label)        { label_template.labels.first }
    subject             { LabelPrinter::DataInput::Label.new(label, label_template.dummy_labels.find(label.name))}

    it "should have the correct name" do
      expect(subject.name).to eq(label.name)
    end

    it "should have the correct number of formats and drawings" do
      expect(subject.formats.count).to eq(label.drawings.count)
      expect(subject.drawings.count).to eq(label.drawings.count)
    end

    it "formats and drawings should be of the correct type and have the correct attributes" do
      barcode = label.barcodes.first
      format = subject.formats.find(barcode.field_name)
      expect(format).to be_xb
      expect(format.x_origin).to eq(barcode.x_origin)
      expect(format.one_module_width).to eq(barcode.one_module_width)

      drawing = subject.drawings.find(barcode.field_name)
      expect(drawing).to be_rb
      expect(drawing.value).to eq(label_template.dummy_labels.find(label.name)[barcode.field_name])

      bitmap = label.bitmaps.first
      format = subject.formats.find(bitmap.field_name)
      expect(format).to be_pc
      expect(format.x_origin).to eq(bitmap.x_origin)
      expect(format.horizontal_magnification).to eq(bitmap.horizontal_magnification)

      drawing = subject.drawings.find(bitmap.field_name)
      expect(drawing).to be_rc
      expect(drawing.value).to eq(label_template.dummy_labels.find(label.name)[bitmap.field_name])
    end

    it "should have the correct list of commands" do
      expect(subject.commands_list).to eq([:formats, "C", :drawings, "XS", "C"])
    end

    it "should produce the correct json" do
      expect(subject.as_json).to eq(label_template.dummy_labels.find(label.name))
    end
  end

  context "DataInput" do

    context "with all sections" do
      subject { LabelPrinter::DataInput.build( label_template, label_template.dummy_labels.to_h ) }

      it "should have the correct feed value" do
        expect(subject.adjust_position.feed_value).to eq(label_template.label_type.feed_value)
      end

      it "should have the correct fine adjustment" do
        expect(subject.adjust_print_density.fine_adjustment).to eq(label_template.label_type.fine_adjustment)
      end

      it "should have the correct pitch length" do
        expect(subject.set_label_size.pitch_length).to eq(label_template.label_type.pitch_length)
      end

      it "should have the correct print width" do
        expect(subject.set_label_size.print_width).to eq(label_template.label_type.print_width)
      end

      it "should have the correct print length" do
        expect(subject.set_label_size.print_length).to eq(label_template.label_type.print_length)
      end

      it "should have the correct labels" do
        expect(subject.labels.count).to eq(label_template.dummy_labels.actual_count)
        label_template.labels.each do |label|
          expect(subject.labels.find(label.name)).to_not be_nil
          expect(subject.labels.find_by(label.name).values).to eq(label_template.dummy_labels.find(label.name))
        end
      end

      it "should have the correct list of commands" do
        expect(subject.commands_list).to eq([:set_label_size, :adjust_print_density, :adjust_position, "T", :labels])
      end

      it "should produce the correct json" do
        expect(subject.as_json).to eq(label_template.dummy_labels.to_h)
      end

      it "should produce the correct output" do
        expect(subject.to_s).to eq( subject.set_label_size.to_s <<
                                      subject.adjust_print_density.to_s <<
                                      subject.adjust_position.to_s <<
                                      LabelPrinter::Commands::Feed.command <<
                                      subject.labels.to_s)
      end

      it "properly encodes the label data with CP-850" do
        expect(subject.to_s.encoding).to eql Encoding::CP850
      end

    end

  end
end
