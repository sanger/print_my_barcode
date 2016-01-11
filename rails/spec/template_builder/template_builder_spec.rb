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
      expect(subject.header).to be_header
      expect(subject.header.values).to eq(label_template.field_names.dummy_values[:header])

      expect(subject.label).to be_label
      expect(subject.label.values).to eq(label_template.field_names.dummy_values[:label])

      expect(subject.footer).to be_footer
      expect(subject.footer.values).to eq(label_template.field_names.dummy_values[:footer])
    end

    it "commands list should be correct" do
      expect(subject.commands_list).to eq([:set_label_size, :adjust_print_density, :adjust_position, "T", :header, :label, :footer])
    end

    it "should produce the correct json" do
      expect(subject.as_json).to eq({ header: label_template.field_names.dummy_values[:header], label: label_template.field_names.dummy_values[:label], footer: label_template.field_names.dummy_values[:footer]})
    end

  end

  context "with a section missing" do
    subject                 { TemplateBuilder.new( label_template, label_template.field_names.dummy_values.except(:header) ) }

    it "should not create the missing section" do
      expect(subject.header).to be_nil
    end

    it "should produce the correct json" do
      expect(subject.as_json).to eq({ header: nil, label: label_template.field_names.dummy_values[:label], footer: label_template.field_names.dummy_values[:footer]})
    end
  end

end