Spree::StoreController::THEME_VIEW_LOAD_PATH = File.join(Spree::Theme::CURRENT_THEME_PATH, 'views')

module Spree
  StoreController.class_eval do

    prepend_view_path Spree::ThemesTemplate::Resolver.new(Spree::StoreController::THEME_VIEW_LOAD_PATH)

  end
end
