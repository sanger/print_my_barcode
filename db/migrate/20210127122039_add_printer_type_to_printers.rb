class AddPrinterTypeToPrinters < ActiveRecord::Migration[5.2]
  def change
    add_column :printers, :printer_type, :integer
  end
end
