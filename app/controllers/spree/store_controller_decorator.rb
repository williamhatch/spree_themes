module Spree
  StoreController.class_eval do

    prepend_view_path Spree::ThemesTemplate::Resolver.new('public/themes/current/views')

  end
end
