module Spree
  class ThemeGeneratorService

    require 'spree_themes'

    def initialize(theme_name)
      @theme_name = theme_name
      generate_views
      generate_stylesheet
      generate_javascript
      update_head
      add_seeds
    end

    def generate_stylesheet
      content = "/*\n*= require #{ @theme_name }/spree/frontend/general\n*= require spree/frontend/all\n*/"
      generate_file(stylesheets_path, content)
      generate_file(::SpreeThemes::Engine.root.join('vendor', 'assets', 'stylesheets', @theme_name, 'spree', 'frontend', 'general.css'), '')
    end

    def generate_javascript
      content = "//= require #{ @theme_name }/spree/frontend/general\n//= require spree/frontend/all"
      generate_file(javascripts_path, content)
      generate_file(::SpreeThemes::Engine.root.join('vendor', 'assets', 'javascripts', @theme_name, 'spree', 'frontend', 'general.js'), '')
    end

    def generate_views
      FileUtils.cp_r(spree_path + '/app/views/spree/', view_path[0])
    end

    def spree_path
      Gem.loaded_specs['spree_frontend'].full_gem_path
    end

    def view_path
      FileUtils.mkdir_p(::SpreeThemes::Engine.root.join('vendor', @theme_name))
    end

    def stylesheets_path
      FileUtils.mkdir_p(::SpreeThemes::Engine.root.join('vendor', 'assets', 'stylesheets', @theme_name, 'spree', 'frontend'))
      ::SpreeThemes::Engine.root.join('vendor', 'assets', 'stylesheets', @theme_name, 'spree', 'frontend', 'all.css').to_s
    end

    def javascripts_path
      FileUtils.mkdir_p(::SpreeThemes::Engine.root.join('vendor', 'assets', 'javascripts', @theme_name, 'spree', 'frontend'))
      ::SpreeThemes::Engine.root.join('vendor', 'assets', 'javascripts', @theme_name, 'spree', 'frontend', 'all.js').to_s
    end

    def generate_file(path, content)
      File.open(path, 'wb') do |f|
        f.write(content)
      end
    end

    def shared_head_path
      ::SpreeThemes::Engine.root.join('vendor', @theme_name, 'spree', 'shared', '_head.html.erb')
    end

    def update_head
      text = File.read(shared_head_path)
      text.gsub!('spree/frontend/all', "#{ @theme_name }/spree/frontend/all")
      File.open(shared_head_path, 'w') { |file| file.puts text }
    end

    def add_seeds
      file_content = File.read(::SpreeThemes::Engine.root.join('config', 'available_themes.rb'))
      file_content.gsub!(']', "'#{ @theme_name }',\n]")
      File.open(::SpreeThemes::Engine.root.join('config', 'available_themes.rb'), 'w+'){|f| f << file_content }
    end
  end
end
