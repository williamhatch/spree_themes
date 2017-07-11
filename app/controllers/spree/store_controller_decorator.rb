Spree::StoreController::THEME_VIEW_LOAD_PATH = File.join(Spree::Theme::CURRENT_THEME_PATH, 'views')

module Spree
  StoreController.class_eval do

    fragment_cache_key Spree::ThemesTemplate::CacheResolver::FRAGMENT_CACHE_KEY

    prepend_view_path Spree::ThemesTemplate::CacheResolver.new(Spree::StoreController::THEME_VIEW_LOAD_PATH)

  end
end
