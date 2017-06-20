module Spree
  module Admin
    class ThemesController < Spree::Admin::BaseController

      before_action :load_theme, only: :state_change
      before_action :load_themes

      def index
        @theme = Spree::Theme.new
      end

      def upload
        @theme = Spree::Theme.new(theme_params)
        if @theme.save
          flash[:notice] = Spree.t('flash.admin.themes.upload.success', name: @theme.name)
          redirect_to admin_themes_path
        else
          flash[:error] = Spree.t('flash.admin.themes.upload.failure', name: @theme.name)
          render :index
        end
      end

      def state_change
        state = case params[:state]
                when 'compiled' then @theme.compile
                when 'published' then @theme.publish
                else false
                end
        if state
          flash[:notice] = Spree.t('flash.admin.themes.state_change.success', state: params[:state], name: @theme.name)
        else
          flash[:error] = Spree.t('flash.admin.themes.state_change.failure', state: params[:state], name: @theme.name)
        end
        redirect_to admin_themes_path
      end

      private

        def theme_params
          params.require(:theme).permit(:template_file)
        end

        def load_themes
          @themes = Spree::Theme.all
        end

        def load_theme
          @theme = Spree::Theme.find_by(id: params[:theme_id])
          unless @theme
            redirect_to admin_themes_path
          end
        end

    end
  end
end
