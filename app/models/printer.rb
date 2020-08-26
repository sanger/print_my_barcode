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

  after_save do
    existing_printers = `lpstat -a`.split("\n")
    existing_printers.map! { |printer| printer.split(' ').first }
    unless existing_printers.include? name
      if Rails.configuration.auto_create_printer_in_cupsd
        `sudo lpadmin -p #{name} -v socket://#{name}.internal.sanger.ac.uk -E`
      end
    end
  end
end
