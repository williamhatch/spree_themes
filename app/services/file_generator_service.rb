class FileGeneratorService

  attr_reader :template, :theme

  def initialize(template)
    @template = template
    @theme = template.theme
  end

  def self.create(template)
    new(template).send :create
  end

  private

    def create
      FileUtils.mkdir_p(output_directory)
      File.open(filepath, 'w+') { |file| file.puts(template.body) }
    end

    def filepath
      "#{ template.path }/#{ template.name }"
    end

    def output_directory
      File.dirname(filepath)
    end

end
