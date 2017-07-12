Spree::StoreController::THEME_VIEW_LOAD_PATH = File.join(Spree::Theme::CURRENT_THEME_PATH, 'views')

module Spree
  StoreController.class_eval do

    fragment_cache_key Spree::ThemesTemplate::CacheResolver::FRAGMENT_CACHE_KEY

    before_action :set_view_path

    after_action :set_preview_theme, if: :preview_mode?

    private

      def set_preview_theme
        params.merge!({ mode: 'preview' })
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

  end
end
