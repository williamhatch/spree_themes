module Spree
  class ThemesTemplate < Spree::Base

    DEFAULT_LOCALE = 'en'
    DEFAULT_PATH = "public/themes"

    # this attr attribute is used when templates are created from admin end.
    attr_accessor :created_by_admin

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
    before_validation :set_default_locale, unless: :locale?
    before_create :set_public_path, if: :created_by_admin
    after_save :update_cache_timestamp
    after_save :update_public_file

    ## DELEGATES ##
    delegate :name, to: :theme, prefix: true

    private

      def update_cache_timestamp
        Rails.cache.write(Spree::ThemesTemplate::Resolver.cache_key, Time.now)
      end

      def set_default_locale
        self.locale = DEFAULT_LOCALE
      end

      def set_public_path
        self.path = "#{ DEFAULT_PATH }/#{ theme_name }/#{ path }"
      end

      def update_public_file
        FileGeneratorService.create(self)
      end

  end
end
