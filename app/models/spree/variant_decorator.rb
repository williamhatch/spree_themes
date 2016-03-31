module Spree
  Variant.class_eval do

    before_create :set_maximum_retail_price, if: -> { maximum_retail_price.zero? }

    def size_options_text
      value = self.option_values.joins(:option_type).find_by(spree_option_types: { presentation: 'Size' })
      value.try(:presentation)
    end

    def set_maximum_retail_price
      self.maximum_retail_price = price
    end
  end
end
