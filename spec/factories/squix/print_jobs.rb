# frozen_string_literal: true

FactoryBot.define do
  factory :squix_print_job, class: Squix::PrintJob do
    transient do
      label_template { create(:label_template) }
    end

    printer_name { create(:printer).name }
    label_template_name { label_template.name }
    labels { [{ 'label' => { 'test_attr' => 'test', 'barcode' => '12345' } }] }
    copies { 1 }

    initialize_with { new(printer_name: printer_name, label_template_name: label_template_name, labels: labels, copies: copies)}
  end
end
