Spree::Core::Engine.routes.draw do
  namespace :admin do
    resource :theme, only: [:update, :show]
  end
end
