# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Printer, type: :model do
  it 'should not be valid without a name' do
    expect(build(:printer, name: nil)).to_not be_valid
  end

  it 'should not be valid without a unique name' do
    printer = create(:printer)
    expect(build(:printer, name: printer.name)).to_not be_valid
  end

  it 'should have a valid protocol' do
    printer = create(:printer)
    expect(printer).to be_LPD
    printer.update_attribute(:protocol, 'IPP')
    expect(printer.reload).to be_IPP
  end

  describe 'printer_type' do
    it 'should not be valid without a type' do
      expect(build(:printer, printer_type: nil)).to_not be_valid
    end

    it 'can create a printer with the squix printer_type' do
      printer = create(:squix_printer)
      expect(printer).to be_valid
      expect(printer).to be_squix
    end

    it 'can create a printer with the toshiba printer_type' do
      printer = create(:toshiba_printer)
      expect(printer).to be_valid
      expect(printer).to be_toshiba
    end

  end

end
