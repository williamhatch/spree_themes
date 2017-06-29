Spree::Core::Engine.routes.draw do

  # Add your extension routes here
  namespace :admin do
    resources :themes, only: [:index, :destroy] do

      member do
        patch :state_change
        patch :download
      end

      collection do
        post :upload
      end

      resources :templates, controller: :themes_templates

    end
  end
end
