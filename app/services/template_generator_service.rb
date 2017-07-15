class TemplateGeneratorService

  DEFAULT_LOCALE = 'en'
  FILE_EXTENSIONS = { css: '.css', scss: '.scss', js: '.js', yml: '.yml' }
  IMAGE_EXTENSIONS = ['.png', '.gif', '.jpeg', '.jpg']

  attr_reader :filepath, :theme_template, :theme

  def initialize(filepath, theme)
    @filepath = filepath
    @theme = theme
    @theme_template = build_template
  end

  def generate
    return nil if image_file?(filepath)
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
      File.extname(filename) == FILE_EXTENSIONS[:css] || FILE_EXTENSIONS[:scss]
    end

    def javascript_file?(filename)
      File.extname(filename) == FILE_EXTENSIONS[:js]
    end

    def assets_file?(filename)
      stylesheet_file?(filename) || javascript_file?(filename)
    end

    # FIX_ME_PG:- considering all images used in themes to be kept in images directory. Later invalidate using file content-type.
    def image_file?(filename)
      file_name == 'snapshot.png' || get_path.split('/').include?('images') && IMAGE_EXTENSIONS.include?(File.extname(filename))
    end

    def yml_files?(filename)
      File.extname(filename) == FILE_EXTENSIONS[:yml]
    end

end
