# lib/rails_categorizable/category/dynamic_associations.rb
module RailsCategorizable
  module CategorySub
    module DynamicAssociations
      def self.included(base)
        base.extend(ClassMethods)
      end

      module ClassMethods
        def ensure_categorizable_association(model_name)
          association_method = model_name.underscore.pluralize.to_sym
          categorization_assoc = :"#{model_name.underscore}_categorizations"

          return if reflect_on_association(association_method)

          has_many categorization_assoc,
                   -> { where(categorizable_type: model_name) },
                   class_name: "RailsCategorizable::Categorization",
                   inverse_of: :category

          has_many association_method,
                   through: categorization_assoc,
                   source: :categorizable,
                   source_type: model_name
        end
      end

      def method_missing(method_name, *args, &block)
        model_name_str = method_name.to_s.singularize.capitalize

        if RailsCategorizable.configuration.categorizable_models.include?(model_name_str)
          unless self.class.reflect_on_association(method_name)
            self.class.ensure_categorizable_association(model_name_str)
          end
          send(method_name, *args, &block)
        else
          super
        end
      end

      def respond_to_missing?(method_name, include_private = false)
        model_name_str = method_name.to_s.singularize.capitalize
        RailsCategorizable.configuration.categorizable_models.include?(model_name_str) ||
          super
      end
    end
  end
end
