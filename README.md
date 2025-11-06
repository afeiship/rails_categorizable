# rails_categorizable
> Reusable scoped categories for any Rails model.

## Installation
```ruby
# Gemfile
gem 'rails_categorizable'
gem "rails_categorizable", path: File.expand_path('~/github/rails_categorizable')

# 生成 migrations
rails rails_categorizable:install:migrations

# 生成空配置
rails generate rails_categorizable:install

# 或指定模型
rails generate rails_categorizable:install Post Product
```

## Usage

### 1. 配置可分类模型

在初始化文件中配置哪些模型需要支持分类功能：

```ruby
# config/initializers/rails_categorizable.rb
Rails.application.config.to_prepare do
  RailsCategorizable.configure do |config|
    # 指定需要支持分类的模型
    config.categorizable_models = ["Post", "Product"]
  end

  # 预定义关联以避免 method_missing 开销
  RailsCategorizable.configuration.categorizable_models.each do |model_name|
    RailsCategorizable::Category.ensure_categorizable_association(model_name)
  end
end
```

### 2. 在模型中添加分类功能

在需要分类功能的模型中包含 `Categorizable` 模块：

```ruby
class Post < ApplicationRecord
  include RailsCategorizable::Categorizable
end

class Product < ApplicationRecord
  include RailsCategorizable::Categorizable
end
```

### 3. 使用分类功能

```ruby
# 创建分类
post_category = Post::Category.create!(name: "技术文章", slug: "tech")
product_category = Product::Category.create!(name: "电子产品", slug: "electronics")

# 为模型实例添加分类
post = Post.create!(title: "Rails 指南")
post.categories << post_category

product = Product.create!(name: "iPhone")
product.categories << product_category

# 查询分类
Post::Category.for(:post) # 获取所有 Post 分类
Product::Category.for(:product) # 获取所有 Product 分类

# 通过分类查找模型实例
tech_posts = post_category.posts
electronic_products = product_category.products

# 嵌套分类
parent_category = Post::Category.create!(name: "编程", slug: "programming")
child_category = Post::Category.create!(name: "Ruby", slug: "ruby", parent: parent_category)
```

## Resources
- https://chat.qwen.ai/c/146fc05e-bf34-4c44-a221-62f6c34f6a65
- https://github.com/aric-rails/rails_categorizable-notes