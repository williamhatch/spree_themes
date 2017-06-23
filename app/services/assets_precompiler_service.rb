class AssetsPrecompilerService

  attr_reader :theme, :env, :manifest

  PRECOMPILED_ASSET_PATH = 'public/assets/theme'
  THEME_DEFAULT_ASSET_PATH = 'public/themes/current'

  def initialize
    current_theme
  end

  def minify(options= {})
    options.merge!({ precompile: true }) unless options.key?(:precompile)
    build_environment
    build_manifest
    options[:precompile] ? assets_precompile : manifest
  end

  private

    def current_theme
      @theme ||= Spree::Theme.published.first
    end

    def build_environment
      @env ||= Sprockets::Environment.new()
      prepend_stylesheet_path
      prepend_javascript_path
      set_compressors
    end

    def build_manifest
      @manifest ||= Sprockets::Manifest.new(env, PRECOMPILED_ASSET_PATH)
    end

    def prepend_stylesheet_path
      env.prepend_path("#{ THEME_DEFAULT_ASSET_PATH }/stylesheets")
    end

    def prepend_javascript_path
      env.prepend_path("#{ THEME_DEFAULT_ASSET_PATH }/javascripts")
    end

    def set_compressors
      env.js_compressor  = Rails.application.config.assets.js_compressor
      env.css_compressor = Rails.application.config.assets.css_compressor
    end

    def assets_precompile
      manifest.clobber
      manifest.compile('*')
    end

end
