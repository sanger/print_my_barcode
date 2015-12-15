class AddProtocolToPrinters < ActiveRecord::Migration
  def change
    add_column :printers, :protocol, :integer, default: 0
  end
end
