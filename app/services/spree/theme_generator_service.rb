module Spree
  class ThemeGeneratorService

    require 'spree_themes'
    require 'byebug'

    def initialize(theme_name)
      @theme_name = theme_name
      generate_views
      generate_stylesheet
      generate_images
      generate_font
      generate_javascript
      update_head
      generate_seeds
    end

    def generate_stylesheet
      content = "/*\n*= require spree/frontend/all\n*= require #{ @theme_name }/stylesheets/spree/frontend/general\n*/"
      generate_file(stylesheets_path, content)
      generate_file(::SpreeThemes::Engine.root.join('vendor', 'themes', @theme_name, 'stylesheets', 'spree', 'frontend', 'general.css'), '')
      puts Dir["vendor/themes/#{ @theme_name }/stylesheets/**/*.css"]
    end

    def generate_font
      FileUtils.mkdir_p(::SpreeThemes::Engine.root.join('vendor', 'themes', @theme_name, 'font', 'spree', 'frontend'))
    end

    def generate_images
      FileUtils.mkdir_p(::SpreeThemes::Engine.root.join('vendor', 'themes', @theme_name, 'images', 'spree', 'frontend'))
    end

    def generate_javascript
      content = "//= require spree/frontend/all\n//= require #{ @theme_name }/javascripts/spree/frontend/general"
      generate_file(javascripts_path, content)
      generate_file(::SpreeThemes::Engine.root.join('vendor', 'themes', @theme_name, 'javascripts', 'spree', 'frontend', 'general.js'), '')
      puts Dir["vendor/themes/#{ @theme_name }/javascripts/**/*.js"]
    end

    def generate_views
      FileUtils.cp_r(spree_path + '/app/views/spree/', view_path[0])
      puts Dir["#{ view_path[0] }/**/*.html.erb"]
    end

    def spree_path
      Gem.loaded_specs['spree_frontend'].full_gem_path
    end

    def view_path
      FileUtils.mkdir_p(::SpreeThemes::Engine.root.join('vendor', 'themes', @theme_name, 'views'))
    end

    def stylesheets_path
      FileUtils.mkdir_p(::SpreeThemes::Engine.root.join('vendor', 'themes', @theme_name, 'stylesheets', 'spree', 'frontend'))
      ::SpreeThemes::Engine.root.join('vendor', 'themes', @theme_name, 'stylesheets', 'spree', 'frontend', 'all.css').to_s
    end

    def javascripts_path
      FileUtils.mkdir_p(::SpreeThemes::Engine.root.join('vendor', 'themes', @theme_name, 'javascripts', 'spree', 'frontend'))
      ::SpreeThemes::Engine.root.join('vendor', 'themes', @theme_name, 'javascripts', 'spree', 'frontend', 'all.js').to_s
    end

    def generate_file(path, content)
      File.open(path, 'wb') do |f|
        f.write(content)
      end
    end

    def shared_head_path
      ::SpreeThemes::Engine.root.join('vendor', 'themes', @theme_name, 'views', 'spree', 'shared', '_head.html.erb')
    end

    def update_head
      text = File.read(shared_head_path)
      text.gsub!("stylesheet_link_tag 'spree/frontend/all'", "stylesheet_link_tag '#{ @theme_name }/stylesheets/spree/frontend/all'")
      text.gsub!("javascript_include_tag 'spree/frontend/all'", "javascript_include_tag '#{ @theme_name }/javascripts/spree/frontend/all'")
      File.open(shared_head_path, 'w') { |file| file.puts text }
    end

    def generate_seeds
      available_themes = Dir.entries('vendor/themes/').reject { |file_name| file_name == '.' || file_name == '..' }
      file_content = "AVAILABLE_THEMES = #{ available_themes }"
      File.open(::SpreeThemes::Engine.root.join('config', 'available_themes.rb'), 'w+'){|f| f << file_content }
    end
  end
end
