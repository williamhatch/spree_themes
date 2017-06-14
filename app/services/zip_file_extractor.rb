require 'zip'

class ZipFileExtractor

  OUTPUT_PATH = 'themes/'

  attr_reader :file_path, :theme

  def initialize(file_path, theme)
    @file_path = file_path
    @theme = theme
  end

  def extract
    FileUtils.mkdir_p(output_path)
    parse_file
  end

  private

    def parse_file
      Zip::File.open(file_path) do |zip_file|
        zip_file.each do |file|
          filepath = File.join(output_path, file.name)
          zip_file.extract(file, filepath) unless File.exist?(filepath)
          generate_template(filepath) if File.file?(filepath)
        end
      end
    end

    def output_path
      @output_path ||= OUTPUT_PATH + file_name
    end

    def file_name
      @file_name ||= File.basename(file_path, file_extension)
    end

    def file_extension
      File.extname(file_path)
    end

    def generate_template(filepath)
      TemplateGeneratorService.new(filepath, theme).generate
    end

end
