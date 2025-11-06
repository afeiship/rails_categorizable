module RailsCategorizable
  class InstallGenerator < Rails::Generators::Base
    source_root File.expand_path("templates", __dir__)

    desc "Install rails_categorizable initializer"

    argument :models, type: :array, default: [], banner: "MODEL_NAME"

    def create_initializer_file
      template "initializer.rb", "config/initializers/rails_categorizable.rb"
    end

    def show_readme
      puts "\n✅ rails_categorizable installed!"
      puts "📝 Edit config/initializers/rails_categorizable.rb to add/remove models."
      puts "🚀 Run: rails rails_categorizable:install:migrations"
    end
  end
end