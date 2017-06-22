module Spree
  class Theme::ManifestGenerator < Rails::Generators::Base

    include Thor::Actions

    JAVASCRIPT_PATH = 'vendor/assets/javascripts/spree/frontend/all.js'
    STYLESHEET_PATH = 'vendor/assets/stylesheets/spree/frontend/all.css'

    attr_reader :theme

    def initialize(theme)
      @theme = theme
      super()
    end

    def add_javascript
      append_file JAVASCRIPT_PATH, "//= require #{ theme.name }\n"
    end

    def add_stylesheet
      inject_into_file STYLESHEET_PATH, " *= require #{ theme.name }\n", before: /\*\//, verbose: true
    end

  end
end
