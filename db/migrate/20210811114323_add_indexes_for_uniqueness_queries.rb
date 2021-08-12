class AddIndexesForUniquenessQueries < ActiveRecord::Migration[5.2]
  def change
    add_index :label_templates, :name, unique: true
    add_index :label_types, :name, unique: true
    add_index :printers, :name, unique: true
  end
end
