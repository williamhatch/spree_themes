module SpreeThemes
  class Engine < Rails::Engine
    require 'spree/core'
    require_relative SpreeThemes::Engine.root.join('config', 'available_themes.rb')
    isolate_namespace Spree
    engine_name 'spree_themes'

    # use rspec for tests
    config.generators do |g|
      g.test_framework :rspec
    end

    initializer "asset_paths" do |app|
      Rails.application.config.assets.paths.insert(8,
        root.join('vendor', 'themes').to_s
        )
    end

    initializer "spree_themes.assets.precompile" do |app|
      AVAILABLE_THEMES.each do |theme_name|
        app.config.assets.precompile += ["#{theme_name}/stylesheets/spree/frontend/all.css"]
        app.config.assets.precompile += ["#{theme_name}/javascripts/spree/frontend/all.js"]
      end
    end

    def self.activate
      Dir.glob(File.join(File.dirname(__FILE__), '../../app/**/*_decorator*.rb')) do |c|
        Rails.configuration.cache_classes ? require(c) : load(c)
      end
    end

    config.to_prepare &method(:activate).to_proc
  end
end
