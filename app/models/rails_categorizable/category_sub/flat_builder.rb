# --- FlatBuilder: 将层级结构扁平化为一维数组 ---
module RailsCategorizable
  module CategorySub
    module FlatBuilder
      def self.included(base)
        base.extend(ClassMethods)
      end

      module ClassMethods
        # 扁平化整个分类树
        def flat_tree(options = {})
          all_nodes = includes(:parent).all.to_a # 预加载优化
          flat_array = []
          root_nodes = all_nodes.select(&:parent_id_blank?)

          root_nodes.each do |node|
            flatten_node(node, flat_array, 0, options, all_nodes)
          end

          flat_array
        end

        private

        def flatten_node(node, array, depth, options, all_nodes)
          id_key = options[:id_key] || :id
          name_key = options[:name_key] || :name
          slug_key = options[:slug_key] || :slug
          depth_key = options[:depth_key] || :depth
          prefix_key = options[:prefix_key] || :prefix

          result = {
            id_key => node.id,
            name_key => node.name,
            slug_key => node.slug,
            scope_key: node.scope_key,
            parent_id: node.parent_id,
            depth_key => depth,
          }

          if options[:include_prefix]
            result[prefix_key] = "  " * depth
          end

          # 支持自定义字段
          Array(options[:include]).each do |field|
            result[field] = node.send(field) if node.respond_to?(field)
          end

          array << result

          children = all_nodes.select { |n| n.parent_id == node.id }
          children.each { |child| flatten_node(child, array, depth + 1, options, all_nodes) }
        end
      end
    end
  end
end
