# frozen_string_literal: true

FactoryBot.define do
  factory :printer do
    sequence(:name) { |n| "Printer #{n}" }
    printer_type    { :toshiba }

    # maybe not necessary but more descriptive
    factory :toshiba_printer

    factory :squix_printer do
      printer_type    { :squix }
    end
  end
end
