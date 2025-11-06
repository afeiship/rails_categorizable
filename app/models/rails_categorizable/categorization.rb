module RailsCategorizable
  class Categorization < ActiveRecord::Base
    self.table_name = "rails_categorizations"

    belongs_to :category, class_name: "RailsCategorizable::Category"
    belongs_to :categorizable, polymorphic: true

    validate :category_scope_must_match_categorizable_type

    private

    def category_scope_must_match_categorizable_type
      expected_scope = categorizable_type&.underscore
      return if expected_scope == category.scope_key
      errors.add(:category, "must have scope_key '#{expected_scope}' for #{categorizable_type}")
    end
  end
end