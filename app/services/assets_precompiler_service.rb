class AssetsPrecompilerService

  attr_reader :theme, :env

  def initialize(theme)
    @theme = theme
  end

  def self.minify(theme)
    new(theme).send :minify
  end

  private

    def minify
      @env = Sprockets::Environment.new()
      prepend_stylesheet_path
      prepend_javascript_path
      manifest = Sprockets::Manifest.new(env, "#{ asset_path }/#{ theme.name }.json")
      manifest.compile('*')
    end

    def prepend_stylesheet_path
      env.prepend_path("#{ asset_path }/stylesheets")
    end

    def prepend_javascript_path
      env.prepend_path("#{ asset_path }/javascripts")
    end

    def asset_path
      "public/themes/#{ theme.name }"
    end

end
