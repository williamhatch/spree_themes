class AssetsPrecompilerService

  attr_reader :theme, :env, :manifest

  PUBLIC_PRECOMPILED_ASSET_PATH = File.join('public', 'assets', 'vinsol_spree_theme')
  PUBLIC_PRECOMPILED_ASSET_PATH_FOR_PREVIEW = File.join('public', 'assets', 'preview_vinsol_spree_theme')
  THEME_PATH = File.join('public', 'vinsol_spree_themes')
  CURRENT_THEME_PATH = File.join(THEME_PATH, 'current')

  def initialize(theme)
    @theme = theme
  end

  def minify(options= {})
    options.merge!({ precompile: true }) unless options.key?(:precompile)
    build_environment
    build_manifest
    options[:precompile] ? assets_precompile : manifest
  end

  def copy_assets
    source_path = File.join(CURRENT_THEME_PATH, 'precompiled_assets', '.')

    FileUtils.rm_r(PUBLIC_PRECOMPILED_ASSET_PATH) if File.exists?(PUBLIC_PRECOMPILED_ASSET_PATH)
    FileUtils.mkdir_p(PUBLIC_PRECOMPILED_ASSET_PATH)
    FileUtils.cp_r(source_path, PUBLIC_PRECOMPILED_ASSET_PATH)
  end

  def copy_preview_assets
    source_path = File.join(theme_path, 'precompiled_assets', '.')

    FileUtils.rm_r(PUBLIC_PRECOMPILED_ASSET_PATH_FOR_PREVIEW) if File.exists?(PUBLIC_PRECOMPILED_ASSET_PATH_FOR_PREVIEW)
    FileUtils.mkdir_p(PUBLIC_PRECOMPILED_ASSET_PATH_FOR_PREVIEW)
    FileUtils.cp_r(source_path, PUBLIC_PRECOMPILED_ASSET_PATH_FOR_PREVIEW)
  end

  private

    def build_environment
      @env ||= Sprockets::Environment.new()
      prepend_stylesheet_path
      prepend_javascript_path
      prepend_images_path
      prepend_fonts_path
      set_compressors
    end

    def build_manifest
      @manifest ||= Sprockets::Manifest.new(env, File.join(theme_path, 'precompiled_assets'))
    end

    def prepend_stylesheet_path
      env.prepend_path(File.join(source_asset_path, 'stylesheets'))
    end

    def prepend_javascript_path
      env.prepend_path(File.join(source_asset_path, 'javascripts'))
    end

    def prepend_images_path
      env.prepend_path(File.join(source_asset_path, 'images'))
    end

    def prepend_fonts_path
      env.prepend_path(File.join(source_asset_path, 'fonts'))
    end

    def set_compressors
      env.js_compressor  = Rails.application.config.assets.js_compressor
      env.css_compressor = Rails.application.config.assets.css_compressor
    end

    def assets_precompile
      manifest.clobber
      manifest.compile('*')
    end

    def source_asset_path
      theme.published? ? CURRENT_THEME_PATH : theme_path
    end

    def theme_path
      File.join(THEME_PATH, theme.name)
    end

end
