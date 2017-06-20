Spree::Core::Engine.routes.draw do

  # Add your extension routes here
  namespace :admin do
    resources :themes, only: :index do
      patch :activate
      patch :deactivate

      collection do
        post :upload
      end

      resources :templates, controller: :themes_templates

    end
  end
end
