require "rails_helper"

RSpec.describe TemplateBuilder, type: :model do |variable|
  
  let!(:header)           { create(:header_with_drawings) }
  let(:header_values)     { header.drawings.pluck(:field_name).to_h_derived }
  let!(:label)            { create(:label_with_drawings) }
  let(:label_values)      { label.drawings.pluck(:field_name).to_h_derived }
  let!(:footer)           { create(:footer_with_drawings) }
  let(:footer_values)     { footer.drawings.pluck(:field_name).to_h_derived }
  let!(:label_template)   { create(:label_template, header: header, label: label, footer: footer) }

  context "with all sections" do

    let(:values)            { { header: header_values, label: label_values, footer: footer_values} }
    let!(:label_template)   { create(:label_template, header: header, label: label, footer: footer) }
    subject                 { TemplateBuilder.new( label_template, values ) }

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
      expect(subject.header).to be_header
      expect(subject.header.section).to eq(header)
      expect(subject.header.values).to eq(header_values)

      expect(subject.label).to be_label
      expect(subject.label.section).to eq(label)
      expect(subject.label.values).to eq(label_values)

      expect(subject.footer).to be_footer
      expect(subject.footer.section).to eq(footer)
      expect(subject.footer.values).to eq(footer_values)
    end

    it "commands list should be correct" do
      expect(subject.commands_list).to eq([:set_label_size, :adjust_print_density, :adjust_position, "T", :header, :label, :footer])
    end

    it "should produce the correct json" do
      expect(subject.as_json).to eq({ header: header_values, label: label_values, footer: footer_values})
    end

  end

  context "with a section missing" do
    let(:values)            { { label: label_values, footer: footer_values} }
    subject                 { TemplateBuilder.new( label_template, values ) }

    it "should not create the missing section" do
      expect(subject.header).to be_nil
    end

    it "should produce the correct json" do
      expect(subject.as_json).to eq({ header: nil, label: label_values, footer: footer_values})
    end
  end

end