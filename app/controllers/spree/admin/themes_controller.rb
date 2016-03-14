module Spree
  module Admin
    class ThemesController < Spree::Admin::BaseController

      before_action :load_theme

      def update
        @theme.update_column(:name, params[:theme][:name])
        redirect_to action: :show
      end

      private
        def load_theme
          @theme = Spree::Theme.current
        end

    end
  end
end
