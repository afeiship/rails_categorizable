# --- Ancestry: 查询祖先和后代 ---
module RailsCategorizable
  module CategorySub
    module Ancestry
      # 获取所有祖先节点（从根到父级）
      def ancestors
        anc = []
        current = self.parent
        while current
          anc.unshift(current) # 从根开始
          current = current.parent
        end
        anc
      end

      # 获取所有后代节点
      def descendants
        des = []
        children.includes(:children).each do |child|
          # 预加载优化
          des << child
          des.concat(child.descendants)
        end
        des
      end

      # 获取所有祖先和后代
      def relatives
        ancestors + descendants
      end
    end
  end
end
