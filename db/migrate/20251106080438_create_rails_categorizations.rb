class CreateRailsCategorizations < ActiveRecord::Migration[7.0]
  def change
    create_table :rails_categorizations do |t|
      t.references :category, null: false, foreign_key: { to_table: :rails_categories }
      t.references :categorizable, polymorphic: true, null: false
      t.timestamps
    end

    add_index :rails_categorizations, [:categorizable_type, :categorizable_id]
    add_index :rails_categorizations, [:category_id, :categorizable_type], unique: true
  end
end