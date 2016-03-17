module Spree
  module Admin
    module ThemesHelper
      def available_themes
        @available_themes ||=  Dir.human_entries(Rails.root.join('vendor', 'themes'))
        unless @available_themes.include?('default')
          @available_themes.push('default')
        end
        @available_themes
      end
    end
  end
end
