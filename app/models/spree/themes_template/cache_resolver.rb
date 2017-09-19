module Spree
  class ThemesTemplate::CacheResolver < ActionView::FileSystemResolver

    FRAGMENT_CACHE_PATH_REGEX = /\A(views\/spree_cache)/
    FRAGMENT_CACHE_KEY = 'spree_cache'

    def initialize(path)
      super(path)
    end

    def find_all(*args)
      clear_cache_if_necessary
      super
    end

    def self.cache_key
      ActiveSupport::Cache.expand_cache_key('updated_at', 'loaded_templates')
    end

    private

      def clear_cache_if_necessary
        last_updated = Rails.cache.fetch(Spree::ThemesTemplate::CacheResolver.cache_key) { Time.current }

        if @cache_last_updated.nil? || @cache_last_updated < last_updated
          Rails.logger.info 'Expiring cache and reloading new template content....'
          # expiring fragment caching used in spree views 
          ActionController::Base.new().expire_fragment(FRAGMENT_CACHE_PATH_REGEX)
          # clearing template caching.
          clear_cache

          @cache_last_updated = last_updated
        end
      end

  end
end
