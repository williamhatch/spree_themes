module Spree
  FrontendHelper.class_eval do
    def link_to_cart(text = nil)
      css_class = nil

      if simple_current_order.nil? or simple_current_order.item_count.zero?
        text = "<span class='glyphicon glyphicon-shopping-cart'></span> 0"
        css_class = 'empty'
      else
        text = "<span class='glyphicon glyphicon-shopping-cart'></span> #{simple_current_order.item_count}"
        css_class = 'full'
      end

      link_to text.html_safe, spree.cart_path, :class => "cart-info #{css_class}"
    end
  end
end
