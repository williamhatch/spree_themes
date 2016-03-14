module Spree
  StoreController.class_eval do
    before_action :prepend_view

    def prepend_view
      prepend_view_path ::SpreeThemes::Engine.root.join('vendor', 'themes', 'dark', 'views')
    end
  end
end
