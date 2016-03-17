module Spree
  StoreController.class_eval do
    before_action :prepend_view

    def prepend_view
      prepend_view_path Rails.root.join('vendor', 'themes', Spree::Config[:theme_name], 'views')
    end
  end
end
