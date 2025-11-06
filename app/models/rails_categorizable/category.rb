module RailsCategorizable
  class Category < ActiveRecord::Base
    self.table_name = "rails_categories"

    before_validation :set_default_slug, on: :create

    belongs_to :parent,
               class_name: "RailsCategorizable::Category",
               optional: true,
               inverse_of: :children

    has_many :children,
             class_name: "RailsCategorizable::Category",
             foreign_key: :parent_id,
             dependent: :destroy,
             inverse_of: :parent

    has_many :categorizations,
             class_name: "RailsCategorizable::Categorization",
             dependent: :destroy

    validates :name, presence: true
    validates :slug, presence: true
    validates :scope_key, presence: true
    validates :name, uniqueness: { scope: :scope_key }
    validates :slug, uniqueness: { scope: :scope_key }
    validate :parent_must_have_same_scope_key

    scope :for, ->(key) { where(scope_key: key.to_s) }

    # ------------------------------------------------------------
    # 动态反向关联支持（如 c1.posts, c1.products）
    # 需在 initializer 中配置:
    #   RailsCategorizable.configure { |c| c.categorizable_models = ["Post", "Product"] }
    # ------------------------------------------------------------

    # 根据 ID 查找树结构
    def self.tree_structure(root_id = nil, options = {})
      if root_id
        root_node = find(root_id)
        build_subtree(root_node, options)
      else
        # 如果没有指定根节点，则获取所有根节点并构建森林
        roots = where(parent_id: nil)
        roots.map { |root| build_subtree(root, options) }
      end
    end

    def method_missing(method_name, *args, &block)
      model_name_str = method_name.to_s.singularize.capitalize

      if RailsCategorizable.configuration.categorizable_models.include?(model_name_str)
        unless self.class.reflect_on_association(method_name)
          self.class.ensure_categorizable_association(model_name_str)
        end

        # ✅ 关键：不要用 super，而是直接 send 新方法
        # 因为方法现在已存在，send 会成功
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

    # Public class API for dynamic association
    # Public class API for dynamic association
    def self.ensure_categorizable_association(model_name)
      association_method = model_name.underscore.pluralize.to_sym
      categorization_assoc = :"#{model_name.underscore}_categorizations"

      return if reflect_on_association(association_method)

      has_many categorization_assoc,
               -> { where(categorizable_type: model_name) },
               class_name: "RailsCategorizable::Categorization",
               inverse_of: :category

      # ✅ 关键：添加 source_type: model_name
      has_many association_method,
               through: categorization_assoc,
               source: :categorizable,
               source_type: model_name
    end

    # =========================  private =============================
    private

    def set_default_slug
      return unless slug.blank?
      self.slug = SecureRandom.uuid.delete('-')[0..11]
    end

    def parent_must_have_same_scope_key
      return unless parent
      return if parent.scope_key == scope_key
      errors.add(:parent, "must belong to the same scope (#{scope_key})")
    end

    # 递归构建子树结构
    def self.build_subtree(node, options = {})
      # 处理字段映射选项
      id_key = options[:id_key] || :id
      name_key = options[:name_key] || :name
      slug_key = options[:slug_key] || :slug
      children_key = options[:children_key] || :children
      parent_id_key = options[:parent_id_key] || :parent_id
      
      result = {}
      result[id_key] = node.id
      result[name_key] = node.name
      result[slug_key] = node.slug
      result[:scope_key] = node.scope_key
      result[parent_id_key] = node.parent_id
      
      # 支持自定义额外字段
      if options[:include]
        Array(options[:include]).each do |field|
          result[field] = node.send(field) if node.respond_to?(field)
        end
      end
      
      result[children_key] = node.children.map { |child| build_subtree(child, options) }
      result
    end
  end
end