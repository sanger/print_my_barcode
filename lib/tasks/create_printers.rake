# frozen_string_literal: true

# Can only run in production, unless config for auto_create_printer_in_cupsd is changed
namespace :printers do
  desc 'generate list of printers'
  task create: :environment do |_t|
    existing_printers = `lpstat -a`.split("\n")
    existing_printers.map! { |printer| printer.split(' ').first }
    Printer.all.each do |printer|
      printer.check_if_printer_exists(existing_printers)
    end
  end
end
