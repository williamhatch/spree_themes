require 'zip'

class ZipFileExtractor

  OUTPUT_PATH = 'public/themes/'

  attr_reader :file_path, :theme

  def initialize(file_path, theme)
    @file_path = file_path
    @theme = theme
  end

  def extract
    FileUtils.mkdir_p(OUTPUT_PATH)
    parse_file
  end

  private

    def parse_file
      Zip::File.open(file_path) do |zip_file|
        zip_file.each do |file|
          filepath = File.join(output_path, file.name)

          #FIXME_AB: maintain an array of ignored files. any file with starting as . or __ should be ignored. Add this in Readme too
          next if filepath =~ /__MACOSX/ or filepath =~ /\.DS_Store/
          unless File.exist?(filepath)
            FileUtils::mkdir_p(File.dirname(filepath))
            zip_file.extract(file, filepath)
          end
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
