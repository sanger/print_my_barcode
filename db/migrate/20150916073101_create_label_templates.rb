# frozen_string_literal: true

class CreateLabelTemplates < ActiveRecord::Migration[4.2]
  def change
    create_table :label_templates do |t|
      t.string :name
      t.references :label_type, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
