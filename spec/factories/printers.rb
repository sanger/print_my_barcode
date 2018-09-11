# frozen_string_literal: true

FactoryBot.define do
  factory :printer do
    sequence(:name) { |n| "Printer #{n}" }
  end
end
