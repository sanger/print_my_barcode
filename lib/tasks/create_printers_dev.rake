# frozen_string_literal: true

namespace :printers_dev do
  desc 'Create printers for development environment'
  task create: :environment do
    if Rails.env.development?
      initial_printers = Printer.count

      # a subset of printers copied from the production environment
      Printer.find_or_create_by(name: 'stub', protocol: 'LPD', printer_type: 'squix')
      Printer.find_or_create_by(name: 'ippbc', protocol: 'LPD', printer_type: 'toshiba')
      Printer.find_or_create_by(name: 'e367bc', protocol: 'LPD', printer_type: 'toshiba')
      Printer.find_or_create_by(name: 'd304bc', protocol: 'LPD', printer_type: 'toshiba')
      Printer.find_or_create_by(name: 'f225bc', protocol: 'LPD', printer_type: 'toshiba')
      Printer.find_or_create_by(name: 'h105bc2', protocol: 'LPD', printer_type: 'toshiba')
      Printer.find_or_create_by(name: 'aa312bc', protocol: 'LPD', printer_type: 'squix')

      final_printers = Printer.count
      puts "Created #{final_printers - initial_printers} Printers"
    else
      puts 'This task can only be run in development environment'
    end
  end
end
