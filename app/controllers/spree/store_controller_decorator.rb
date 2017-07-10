Spree::StoreController::THEME_VIEW_LOAD_PATH = File.join(Spree::Theme::CURRENT_THEME_PATH, 'views')

module Spree
  StoreController.class_eval do

    fragment_cache_key Spree::FragmentCacheController::CACHE_KEY

    prepend_view_path Spree::ThemesTemplate::Resolver.new(Spree::StoreController::THEME_VIEW_LOAD_PATH)

    # FIX_ME_PG:- Currently expiring all frament cache. Need to clear only when caching is present in page.
    before_action ->() { Spree::FragmentCacheController.new.clear_cache }

  end
end
