class TemplateGeneratorService

  DEFAULT_LOCALE = 'en'

  attr_reader :filepath, :theme_template, :theme

  def initialize(filepath, theme)
    @filepath = filepath
    @theme = theme
    @theme_template = Spree::ThemesTemplate.new
  end

  def generate
    theme_template.assign_attributes(template_attributes)
    theme_template.save
  end

  private

    def template_attributes
      { 
        body: File.read(filepath),
        path: get_path,
        partial: is_partial?,
        handler: get_handler,
        format: get_format,
        locale: DEFAULT_LOCALE,
        theme_id: theme.id
      }
    end

    def get_path
      dir = File.dirname(filepath)
      dir.slice!("themes/#{ theme.name }/views/")
      filename = file_name.split('.')[0]
      # In spree few `.js.erb` files related to google are rendered in html format and searches for `filename.js` file.
      if script_embeded_partial?
        "#{ dir }/#{ filename }.js"
      elsif stylesheet_file?(filepath)
        "#{ dir }/#{ filename }.css"
      else
        "#{ dir }/#{ filename }"
      end
    end

    def is_partial?
      file_name.starts_with?('_')
    end

    def get_handler
      return nil if stylesheet_file?(filepath)
      File.extname(filepath).gsub('.', '')
    end

    def get_format
      return nil if stylesheet_file?(filepath)
      # In spree few `.js.erb` files related to google are rendered in html format.
      script_embeded_partial? ? 'html' : format
    end

    def script_embeded_partial?
      is_partial? && format.eql?('js')
    end

    def file_name
      File.basename(filepath)
    end

    def format
      file_name_without_ext.split('.')[-1]
    end

    def file_name_without_ext
      File.basename(filepath, get_handler)
    end

    def stylesheet_file?(filename)
      File.extname(filename) == '.css'
    end


end
