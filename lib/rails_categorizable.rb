require "rails_categorizable/engine"
require "rails_categorizable/version"
require "rails_categorizable/configuration"

module RailsCategorizable
  autoload :Categorizable, "rails_categorizable/categorizable"

  class << self
    attr_writer :configuration
  end

  def self.configuration
    @configuration ||= Configuration.new
  end

  def self.configure
    yield(configuration)
  end
end