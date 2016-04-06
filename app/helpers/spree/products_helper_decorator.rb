module Spree
  ProductsHelper.class_eval do
    def cache_key_for_products
      count = @products.count
      max_updated_at = (@products.maximum(:updated_at) || Date.today).to_s(:number)
      "#{I18n.locale}/#{current_currency}/spree/products/all-#{params[:page]}-#{max_updated_at}-#{count}-#{Spree::Config[:theme_name]}"
    end
  end
end
