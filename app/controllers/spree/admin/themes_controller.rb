module Spree
  module Admin
    class ThemesController < Spree::Admin::BaseController

      def update
        Spree::Config[:theme_name] = params[:theme][:name]
        redirect_to action: :show
      end

    end
  end
end
