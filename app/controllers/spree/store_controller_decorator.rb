module Spree
  StoreController.class_eval do

    # prepend_view_path Spree::ThemesTemplate::Resolver.instance

    #FIX_ME_PG:- Need to figure out a way to prepend dynamic view paths according to theme. Currently hardcoded.
    prepend_view_path 'public/themes/default/views'

  end
end
