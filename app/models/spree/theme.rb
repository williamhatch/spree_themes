module Spree
  class Theme < Spree::Base
    singleton_class.send(:alias_method, :current, :first)
  end
end
