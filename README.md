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

## Resources
- https://chat.qwen.ai/c/146fc05e-bf34-4c44-a221-62f6c34f6a65