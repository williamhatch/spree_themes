module Spree
  class Theme < Spree::Base
    scope :current, -> { first }
  end
end
