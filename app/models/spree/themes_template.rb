module Spree
  class ThemesTemplate < Spree::Base

    ## VALIDATIONS ##
    validates :path, presence: true
    validates :format, inclusion: Mime::SET.symbols.map(&:to_s),
                       allow_nil: true
    validates :locale, inclusion: I18n.available_locales.map(&:to_s)
    validates :handler, inclusion: ActionView::Template::Handlers.extensions.map(&:to_s),
                        allow_nil: true

    ## ASSOCIATIONS ##
    belongs_to :theme

    ## CALLBACKS ##
    after_save :clear_cache

    private

      def clear_cache
        Spree::ThemesTemplate::Resolver.instance.clear_cache
      end

  end
end
