module Spree
  module Admin
    class ThemesController < Spree::Admin::BaseController

      before_action :load_theme, only: [:activate, :deactivate]
      before_action :load_themes

      def index
        @theme = Spree::Theme.new
      end

      def upload
        @theme = Spree::Theme.new(theme_params)
        if @theme.save
          redirect_to admin_themes_path
        else
          render :index
        end
      end

      def activate
        if @theme.activate!
          redirect_to admin_themes_path
        else
          render :index
        end
      end

      def deactivate
        if @theme.deactivate!
          redirect_to admin_themes_path
        else
          render :index
        end
      end

      private

        def theme_params
          params.require(:theme).permit(:template_file)
        end

        def load_theme
          @theme = Spree::Theme.find_by(id: params[:theme_id])
          unless @theme
            redirect_to admin_themes_path
          end
        end

        def load_themes
          @themes = Spree::Theme.all
        end

    end
  end
end
