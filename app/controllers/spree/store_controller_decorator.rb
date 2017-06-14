module Spree
  StoreController.class_eval do

    prepend_view_path Spree::ThemesTemplate::Resolver.instance

  end
end
