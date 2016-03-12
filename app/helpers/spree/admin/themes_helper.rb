module Spree
  module Admin
    module ThemesHelper
      def available_themes
        Dir.entries(Gem.loaded_specs['spree_themes'].full_gem_path + '/vendor' + '/themes').select {|f| !File.directory? f}.push('default')
      end
    end
  end
end
