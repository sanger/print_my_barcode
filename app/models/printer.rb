# frozen_string_literal: true

##
# A networked printer. The name will correspond to it's network name.
# Each printer is identified by the protocol it will use.
# A printer will either implement the IPP or LPD protocol
# The TOF protocol implements the ability to send the print job to a file.
class Printer < ApplicationRecord
  include Filterable

  validates :name, presence: true, uniqueness: { case_sensitive: false }

  enum protocol: %i[LPD IPP TOF]

  before_filter do |filters|
    if filters.key?(:protocol)
      filters.merge!(protocol: protocols[filters[:protocol]])
    else
      filters
    end
  end

  after_save :update_printer_in_cups

  def update_printer_in_cups
    return unless Rails.configuration.auto_create_printer_in_cupsd

    existing_printers = Printer.existing_cups_printers
    check_if_printer_exists(existing_printers)
  end

  def check_if_printer_exists(existing_printers)
    return if existing_printers.include? name

    `./create-cups-printer.sh #{name}`
  end

  def self.existing_cups_printers
    existing_printers = `lpstat -a`.split("\n")
    existing_printers.map! { |printer| printer.split(' ').first }
    existing_printers
  end
end
