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
    it 'should not be valid without a name' do
      expect(build(:printer, printer_type: nil)).to_not be_valid
    end

    it 'should create a printer with the squix printer_type' do
      printer = create(:printer, printer_type: :squix)
      expect(printer.printer_type).to eq 'squix'
      expect(printer.squix?).to be_truthy
    end

    it 'should create a printer with the toshiba printer_type' do
      printer = create(:printer, printer_type: :toshiba)
      expect(printer.printer_type).to eq 'toshiba'
      expect(printer.toshiba?).to be_truthy
    end

    it 'should not be valid without a printer_type' do
      expect(build(:printer, name: nil)).to_not be_valid
    end

    it 'should be valid with a printer_type' do
      expect(build(:printer, printer_type: :squix)).to be_valid
    end

    it 'should be valid with a printer_type' do
      expect(build(:printer, printer_type: :toshiba)).to be_valid
    end
  end

end
