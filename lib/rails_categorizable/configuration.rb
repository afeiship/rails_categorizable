module RailsCategorizable
  class Configuration
    attr_accessor :categorizable_models

    def initialize
      @categorizable_models = []
    end

    # 提供便捷方法：自动转为字符串（兼容传入类的情况）
    def categorizable_models=(models)
      @categorizable_models = models.map(&:to_s)
    end
  end
end