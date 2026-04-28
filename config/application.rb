require_relative "boot"
require "rails/all"

Bundler.require(*Rails.groups)

module Bookmangal
  class Application < Rails::Application
    config.load_defaults 8.0
    config.autoload_lib(ignore: %w[assets tasks])
    config.i18n.default_locale = :en
    config.time_zone = "Europe/Kyiv"
  end
end
