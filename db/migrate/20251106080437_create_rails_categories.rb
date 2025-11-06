class CreateRailsCategories < ActiveRecord::Migration[7.0]
  def change
    create_table :rails_categories do |t|
      t.string :name, null: false
      t.string :scope_key, null: false, default: "default"
      t.references :parent,
                   foreign_key: { to_table: :rails_categories },
                   index: true,
                   null: true
      t.timestamps
    end

    add_index :rails_categories, [:scope_key, :parent_id]
    add_index :rails_categories, [:scope_key, :name], unique: true
  end
end