# lib/rails_categorizable/category/tree_builder.rb
module RailsCategorizable
  module CategorySub
    module TreeBuilder
      def self.included(base)
        base.extend(ClassMethods)
      end

      module ClassMethods
        def tree(root_id = nil, options = {})
          if root_id
            root_node = find(root_id)
            build_subtree(root_node, options)
          else
            roots = where(parent_id: nil)
            roots.map { |root| build_subtree(root, options) }
          end
        end

        private

        def build_subtree(node, options = {})
          id_key = options[:id_key] || :id
          name_key = options[:name_key] || :name
          slug_key = options[:slug_key] || :slug
          children_key = options[:children_key] || :children
          parent_id_key = options[:parent_id_key] || :parent_id
          recursive = options.key?(:recursive) ? options[:recursive] : true

          result = {
            id_key => node.id,
            name_key => node.name,
            slug_key => node.slug,
            scope_key: node.scope_key,
            parent_id_key => node.parent_id,
          }

          # 支持自定义字段
          Array(options[:include]).each do |field|
            result[field] = node.send(field) if node.respond_to?(field)
          end

          if recursive
            result[children_key] = node.children.map { |child| build_subtree(child, options) }
          else
            result[children_key] = node.children.map { |child| build_leaf(child, options) }
          end
          result
        end

        def build_leaf(node, options = {})
          id_key = options[:id_key] || :id
          name_key = options[:name_key] || :name
          slug_key = options[:slug_key] || :slug
          children_key = options[:children_key] || :children
          parent_id_key = options[:parent_id_key] || :parent_id

          result = {
            id_key => node.id,
            name_key => node.name,
            slug_key => node.slug,
            scope_key: node.scope_key,
            parent_id_key => node.parent_id,
          }

          Array(options[:include]).each do |field|
            result[field] = node.send(field) if node.respond_to?(field)
          end

          result[children_key] = []
          result
        end
      end
    end
  end
end
