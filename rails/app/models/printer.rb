##
# A networked printer. The name will correspond to it's network name.
# Each printer is identified by the protocol it will use.
# A printer will either implement the IPP or LPD protocol
# The TOF protocol implements the ability to send the print job to a file.
class Printer < ActiveRecord::Base

  include Filterable

  validates :name, presence: true, uniqueness: {case_sensitive: false}

  enum protocol: [:LPD, :IPP, :TOF]

  before_filter do |filters|
    filters.has_key?(:protocol) ? filters.merge!(protocol: protocols[filters[:protocol]]) : filters
  end

end