class CreateRailsCategories < ActiveRecord::Migration[7.0]
  def change
    create_table :rails_categories do |t|
      t.string :name, null: false
      t.string :slug, null: false
      t.string :scope_key, null: false, default: "default"
      t.references :parent,
                   foreign_key: { to_table: :rails_categories },
                   index: true,
                   null: true

      # SEO 字段
      t.string :seo_title
      t.string :seo_keywords
      t.text :seo_description

      t.timestamps
    end

    # 索引（全部显式命名，确保 < 64 字符）
    add_index :rails_categories,
              [:scope_key, :parent_id],
              name: "idx_rails_categories_scope_parent"

    add_index :rails_categories,
              [:scope_key, :name],
              unique: true,
              name: "idx_rails_categories_scope_name_uniq"

    add_index :rails_categories,
              [:scope_key, :slug],
              unique: true,
              name: "idx_rails_categories_scope_slug_uniq"
  end
end