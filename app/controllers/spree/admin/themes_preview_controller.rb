module Spree
  module Admin
    class ThemesPreviewController < Spree::Admin::BaseController

      before_action :load_theme, only: :show

      def show
        session[:preview] = @theme.name
        @theme.assets_precompile
        redirect_to root_path(theme: @theme.id, mode: 'preview')
      end

      def destroy
        session.delete(:preview)
        redirect_to admin_themes_path
      end

      private

        def load_theme
          @theme = Spree::Theme.find_by(id: params[:theme_id])
          unless @theme
            redirect_to admin_themes_path
          end
        end

    end
  end
end
