module RailsCategorizable
  # --- Sorter: 按层级排序 ---
  module CategorySub
    module Sorter
      def self.included(base)
        base.extend(ClassMethods)
      end

      module ClassMethods
        # 按层级顺序排序，根节点在前，子节点紧跟其后
        def sorted_by_level
          flat_tree.map { |flat_node| find(flat_node[:id]) }
        end
      end
    end
  end
end
