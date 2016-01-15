require "rails_helper"

RSpec.describe TemplateBuilder, type: :model do |variable|

  let!(:label_template)  { create(:label_template)}

  context "with all sections" do

    subject                 { TemplateBuilder.new( label_template, label_template.field_names.dummy_values ) }

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

    it "should create the appropriate sections" do
      subject.headers.each_with_index do |header, i|
        expect(header).to be_header
        expect(header.values).to eq(label_template.field_names.dummy_values[:headers][i])
      end

      subject.labels.each_with_index do |label, i|
        expect(label).to be_label
        expect(label.values).to eq(label_template.field_names.dummy_values[:labels][i])
      end

      subject.footers.each_with_index do |footer, i|
        expect(footer).to be_footer
        expect(footer.values).to eq(label_template.field_names.dummy_values[:footers][i])
      end

    end

    it "commands list should be correct" do
      expect(subject.commands_list).to eq([:set_label_size, :adjust_print_density, :adjust_position, "T", :headers, :labels, :footers])
    end

    it "should produce the correct json" do
      expect(subject.as_json).to eq( { headers: label_template.field_names.dummy_values[:headers], labels: label_template.field_names.dummy_values[:labels], footers: label_template.field_names.dummy_values[:footers]})
    end

  end

  context "with a section missing" do
    subject                 { TemplateBuilder.new( label_template, label_template.field_names.dummy_values.except(:headers) ) }

    it "should not create the missing section" do
      expect(subject.headers).to be_nil
    end

    it "should produce the correct json" do
      expect(subject.as_json).to eq({ headers: nil, labels: label_template.field_names.dummy_values[:labels], footers: label_template.field_names.dummy_values[:footers]})
    end
  end

end