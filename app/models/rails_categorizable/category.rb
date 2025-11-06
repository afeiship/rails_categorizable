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

    validates :name, presence: true
    validates :scope_key, presence: true
    validates :name, uniqueness: { scope: :scope_key }
    validate :parent_must_have_same_scope_key

    scope :for, ->(key) { where(scope_key: key.to_s) }

    private

    def parent_must_have_same_scope_key
      return unless parent
      return if parent.scope_key == scope_key
      errors.add(:parent, "must belong to the same scope (#{scope_key})")
    end
  end
end