class TemplateGeneratorService

  DEFAULT_LOCALE = 'en'
  FILE_EXTENSIONS = { css: '.css', js: '.js', yml: '.yml' }

  attr_reader :filepath, :theme_template, :theme

  def initialize(filepath, theme)
    @filepath = filepath
    @theme = theme
    @theme_template = build_template
  end

  def generate
    theme_template.assign_attributes(template_attributes)
    theme_template.save
  end

  private

    def build_template
      @theme.templates.find_or_initialize_by(path: get_path, name: file_name)
    end

    def template_attributes
      { 
        body: File.read(filepath),
        path: get_path,
        partial: is_partial?,
        handler: get_handler,
        format: get_format,
        locale: DEFAULT_LOCALE,
        theme_id: theme.id,
        name: file_name
      }
    end

    def get_path
      File.dirname(filepath)
    end

    def is_partial?
      file_name.starts_with?('_')
    end

    def get_handler
      return nil if assets_file?(filepath) || yml_files?(filepath)
      File.extname(filepath).gsub('.', '')
    end

    def get_format
      return nil if assets_file?(filepath) || yml_files?(filepath)
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
      File.extname(filename) == FILE_EXTENSIONS[:css]
    end

    def javascript_file?(filename)
      File.extname(filename) == FILE_EXTENSIONS[:js]
    end

    def assets_file?(filename)
      stylesheet_file?(filename) || javascript_file?(filename)
    end

    def yml_files?(filename)
      File.extname(filename) == FILE_EXTENSIONS[:yml]
    end

end
