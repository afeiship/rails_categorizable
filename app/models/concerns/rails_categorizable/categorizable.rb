# app/models/concerns/rails_categorizable/categorizable.rb
module RailsCategorizable
  module Categorizable
    extend ActiveSupport::Concern

    included do
      # 1. 自动定义嵌套 Category 类
      unless const_defined?(:Category)
        const_set :Category, build_category_proxy(self)
      end

      # 2. 关联关系
      has_many :categorizations,
               as: :categorizable,
               class_name: "RailsCategorizable::Categorization",
               dependent: :destroy

      has_many :categories,
               through: :categorizations,
               source: :category,
               class_name: "RailsCategorizable::Category"
    end

    class_methods do
      private

      def build_category_proxy(base_class)
        scope_key = base_class.name.underscore

        Class.new(RailsCategorizable::Category) do
          define_singleton_method :scope_key do
            scope_key
          end

          default_scope { where(scope_key: scope_key) }

          # ✅ 修复：接受 hash，不是 keyword args
          def self.create!(attributes = {})
            super(attributes.merge(scope_key: scope_key))
          end

          def self.name
            "#{base_class.name}::Category"
          end
        end
      end
    end
  end
end