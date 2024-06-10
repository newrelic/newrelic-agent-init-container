require_relative 'boot'

require 'rails'
require 'action_controller/railtie'
require 'action_view/railtie'

Bundler.require(*Rails.groups)

module TestAppRuby
  class Application < Rails::Application
    config.load_defaults 6.0
    config.eager_load_paths << Rails.root.join('lib')
  end
end
