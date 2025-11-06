module RailsCategorizable
  class Engine < ::Rails::Engine
    isolate_namespace RailsCategorizable

    config.autoload_paths += Dir[
      File.join(__dir__, "..", "app", "models", "{concerns,}/**/*.rb")
    ].freeze
  end
end