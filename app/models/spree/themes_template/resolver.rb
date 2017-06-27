module Spree
  class ThemesTemplate::Resolver < ActionView::FileSystemResolver

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
        last_updated = Rails.cache.fetch(Spree::ThemesTemplate::Resolver.cache_key) { Time.current }

        if @cache_last_updated.nil? || @cache_last_updated < last_updated
          Rails.logger.info 'Reloading new template content.....'
          clear_cache
          @cache_last_updated = last_updated
        end
      end

  end
end
