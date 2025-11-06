# lib/rails_categorizable/category.rb
module RailsCategorizable
  class Category < ActiveRecord::Base
    self.table_name = "rails_categories"

    belongs_to :parent,
               class_name: "RailsCategorizable::Category",
               optional: true,
               inverse_of: :children

    has_many :children,
             class_name: "RailsCategorizable::Category",
             foreign_key: :parent_id,
             dependent: :destroy,
             inverse_of: :parent

    has_many :categorizations,
             class_name: "RailsCategorizable::Categorization",
             dependent: :destroy

    validates :name, presence: true, uniqueness: { scope: :scope_key }
    validates :slug, presence: true, uniqueness: { scope: :scope_key }
    validate :parent_must_have_same_scope_key
    before_validation :set_default_slug, on: :create

    scope :for, ->(key) { where(scope_key: key.to_s) }

    # 抽离的模块
    include RailsCategorizable::CategorySub::DynamicAssociations
    include RailsCategorizable::CategorySub::TreeBuilder
    include RailsCategorizable::CategorySub::Validators
  end
end
