module Spree
  StoreController.class_eval do

    prepend_view_path 'public/themes/current/views'

  end
end
