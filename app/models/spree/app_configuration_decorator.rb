module Spree
  AppConfiguration.class_eval do
    preference :theme_name, :string, default: 'default'
  end
end
