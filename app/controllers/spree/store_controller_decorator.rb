Spree::StoreController::THEME_VIEW_LOAD_PATH = File.join(Spree::Theme::CURRENT_THEME_PATH, 'views')

module Spree
  StoreController.class_eval do

    fragment_cache_key Spree::ThemesTemplate::CacheResolver::FRAGMENT_CACHE_KEY

    before_action :set_view_path

    before_action :set_preview_theme, if: [:preview_mode?, :preview_theme]

    private

      def set_preview_theme
        params.merge!({ mode: 'preview', theme:  preview_theme.id })
      end

      def preview_mode?
        current_spree_user.present? && current_spree_user.admin? && session[:preview].present?
      end
      helper_method :preview_mode?

      def set_view_path
        path = preview_mode? ? theme_preview_path : Spree::StoreController::THEME_VIEW_LOAD_PATH
        prepend_view_path path
      end

      def theme_preview_path
        File.join(Spree::Theme::THEMES_PATH, session[:preview], 'views')
      end

      def preview_theme
        @preview_theme ||= Spree::Theme.find_by(name: session[:preview])
      end

  end
end
