require_relative "lib/rails_categorizable/version"

Gem::Specification.new do |spec|
  spec.name        = "rails_categorizable"
  spec.version     = RailsCategorizable::VERSION
  spec.authors     = ["afeiship"]
  spec.email       = ["1290657123@qq.com"]
  spec.homepage    = "https://github.com/afeiship/rails_categorizable"
  spec.summary     = "Reusable scoped categories for any Rails model."
  spec.description = "Adds polymorphic, scope-isolated categories with tree support to Rails apps."
  spec.license     = "MIT"

  spec.required_ruby_version = ">= 2.7.0"
  spec.add_dependency "rails", ">= 6.0"

  spec.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]
  spec.test_files = Dir["test/**/*"]
end