module Spree
  ProductsHelper.class_eval do
    def show_maximum_retail_price(product_or_variant)
      Spree::Price.new(variant_id: product_or_variant.id, currency: product_or_variant.currency, price: product_or_variant.maximum_retail_price).display_price.to_html
    end

    def percentage_diff(product_or_variant)
      @percentage_diff = (((product_or_variant.maximum_retail_price - product_or_variant.price_in(product_or_variant.currency).price) / product_or_variant.maximum_retail_price) * 100).round(2)
      "(#{@percentage_diff}%)" if(@percentage_diff)
    end

    def color_option_value(variant)
      variant.option_values.joins(:option_type).find_by(spree_option_types: { presentation: 'Color' })
    end

    def non_color_option_types(product)
      product.option_types.where.not(presentation: 'Color')
    end

    def cache_key_for_products
      count = @products.count
      max_updated_at = (@products.maximum(:updated_at) || Date.today).to_s(:number)
      "#{I18n.locale}/#{current_currency}/spree/products/all-#{params[:page]}-#{max_updated_at}-#{count}-#{Spree::Config[:theme_name]}"
    end
  end
end
