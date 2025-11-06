# lib/rails_categorizable/category/validators.rb
module RailsCategorizable
  module CategorySub
    module Validators
      def parent_must_have_same_scope_key
        return unless parent
        return if parent.scope_key == scope_key
        errors.add(:parent, "must belong to the same scope (#{scope_key})")
      end

      def set_default_slug
        return unless slug.blank?
        self.slug = SecureRandom.uuid.delete('-')[0..11]
      end
    end
  end
end
