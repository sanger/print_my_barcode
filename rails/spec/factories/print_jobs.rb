FactoryGirl.define do
  factory :print_job, class: LabelPrinter::PrintJob::Base do

    transient do
      label_template { create(:label_template) }
    end

    printer_name { create(:printer).name }
    label_template_id { label_template.id }
    labels { label_template.dummy_labels.to_h }

    initialize_with { new(printer_name: printer_name, label_template_id: label_template_id, labels: labels) }
  end

end