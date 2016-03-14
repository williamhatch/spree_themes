module Spree
  class ThemeGeneratorService

    require 'spree_themes'
    require 'byebug'

    def initialize(theme_name)
      @theme_name = theme_name
    end

    def generate
      puts 'Generating files'
      generate_views
      generate_stylesheet
      generate_images
      generate_font
      generate_javascript
      update_head
      generate_seeds
      puts 'Files generated'
    end

    def generate_views
      FileUtils.cp_r(spree_path + '/app/views/spree/', view_path)
      puts Dir["#{ view_path }/**/*.html.erb"]
    end

    def generate_stylesheet
      generate_file(stylesheets_path, "/*\n*= require spree/frontend/all\n*= require #{ @theme_name }/stylesheets/spree/frontend/general\n*/")
      generate_file(absolute_path(['stylesheets', 'spree', 'frontend', 'general.css']))
      puts Dir["vendor/themes/#{ @theme_name }/stylesheets/**/*.css"]
    end

    def generate_font
      create_recursive_folder(['font', 'spree', 'frontend'])
    end

    def generate_images
      create_recursive_folder(['images', 'spree', 'frontend'])
    end

    def generate_javascript
      generate_file(javascripts_path, "//= require spree/frontend/all\n//= require #{ @theme_name }/javascripts/spree/frontend/general")
      generate_file(absolute_path(['javascripts', 'spree', 'frontend', 'general.js']))
      puts Dir["vendor/themes/#{ @theme_name }/javascripts/**/*.js"]
    end

    def spree_path
      Gem.loaded_specs['spree_frontend'].full_gem_path
    end

    def view_path
      create_recursive_folder(['views'])[0]
    end

    def stylesheets_path
      create_recursive_folder(['stylesheets', 'spree', 'frontend'])
      absolute_path(['stylesheets', 'spree', 'frontend', 'all.css']).to_s
    end

    def javascripts_path
      create_recursive_folder(['javascripts', 'spree', 'frontend'])
      absolute_path(['javascripts', 'spree', 'frontend', 'all.js']).to_s
    end

    def generate_file(path, content='')
      File.open(path, 'wb') do |f|
        f.write(content)
      end
    end

    def create_recursive_folder(path)
      FileUtils.mkdir_p(absolute_path(path))
    end

    def shared_head_path
      absolute_path(['views', 'spree', 'shared', '_head.html.erb'])
    end

    def update_head
      text = File.read(shared_head_path)
      text.gsub!("stylesheet_link_tag 'spree/frontend/all'", "stylesheet_link_tag '#{ @theme_name }/stylesheets/spree/frontend/all'")
      text.gsub!("javascript_include_tag 'spree/frontend/all'", "javascript_include_tag '#{ @theme_name }/javascripts/spree/frontend/all'")
      File.open(shared_head_path, 'w') { |file| file.puts text }
    end

    def generate_seeds
      available_themes = Dir.entries('vendor/themes/').reject { |file_name| file_name == '.' || file_name == '..' }
      file_content = "AVAILABLE_THEMES = #{ available_themes.prepend('default') }"
      File.open(::SpreeThemes::Engine.root.join('config', 'available_themes.rb'), 'w+'){|f| f << file_content }
    end

    def absolute_path(path)
      ::SpreeThemes::Engine.root.join('vendor', 'themes', @theme_name, *path)
    end
  end
end
