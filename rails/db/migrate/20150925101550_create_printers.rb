class CreatePrinters < ActiveRecord::Migration
  def change
    create_table :printers do |t|
      t.string :name

      t.timestamps null: false
    end
  end
end
