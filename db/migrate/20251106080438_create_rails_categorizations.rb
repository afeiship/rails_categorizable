# db/migrate/xxx_create_rails_categorizations.rb
class CreateRailsCategorizations < ActiveRecord::Migration[7.0]
  def change
    create_table :rails_categorizations do |t|
      t.references :category, null: false, foreign_key: { to_table: :rails_categories }
      t.references :categorizable, polymorphic: true, null: false
      t.timestamps
    end

    # 使用 if_not_exists 避免重复创建（Rails 6.1+）
    add_index :rails_categorizations,
              [:categorizable_type, :categorizable_id],
              name: "index_rails_categorizations_on_categorizable",
              if_not_exists: true

    add_index :rails_categorizations,
              [:category_id, :categorizable_type],
              unique: true,
              name: "index_rails_categorizations_on_category_and_type",
              if_not_exists: true
  end
end