# Configure rails_categorizable
Rails.application.config.to_prepare do
  RailsCategorizable.configure do |config|
    config.categorizable_models = [<%= models.map { |m| "\"#{m}\"" }.join(", ") %>]
  end

  # Pre-define associations to avoid method_missing overhead
  RailsCategorizable.configuration.categorizable_models.each do |model_name|
    RailsCategorizable::Category.ensure_categorizable_association(model_name)
  end
end