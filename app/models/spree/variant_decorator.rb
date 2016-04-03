module Spree
  Variant.class_eval do

    before_create :set_maximum_retail_price, if: -> { maximum_retail_price.zero? }

    def set_maximum_retail_price
      self.maximum_retail_price = price
    end
  end
end
