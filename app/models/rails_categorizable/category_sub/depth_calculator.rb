module RailsCategorizable
  module CategorySub
    module DepthCalculator
      def depth
        return 0 if parent_id.nil?

        parent.depth + 1
      end
    end
  end
end
