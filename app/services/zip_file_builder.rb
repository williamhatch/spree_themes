require 'zip'

class ZipFileBuilder

  THEMES_PATH = File.join('public', 'vinsol_spree_themes')
  INVALID_DIRECTORIES = ['.', '..', 'precompiled_assets']

  attr_reader :theme, :entries, :input_path, :output_path, :zip, :name

  def initialize(theme)
    @theme = theme
    @name = name
    input_theme_directory_path
    output_zip_file_path
  end

  def archive
    remove
    @entries = get_directory_content(input_theme_directory_path)
    delete_non_zip_content(@entries)
    build_zip_file
  end

  def remove
    File.delete(output_path) if File.exist?(output_path)
  end

  def name
    "#{ theme.name }.zip"
  end

  private

    def input_theme_directory_path
      @input_path = File.join(THEMES_PATH, theme.name)
    end

    def output_zip_file_path
      @output_path = File.join('tmp', name)
    end

    def get_directory_content(directory_path)
      Dir.entries(directory_path)
    end

    def delete_non_zip_content(entries)
      INVALID_DIRECTORIES.each { |dir| entries.delete(dir) }
    end

    def build_zip_file
      open_zip_file
      write_entries('', entries)
      zip.close();
    end

    def open_zip_file
      @zip = Zip::File.open(output_path, Zip::File::CREATE)
    end

    def write_entries(path, entries)
      entries.each do |e|
        zip_path = path == '' ? e : File.join(path, e)
        filepath = File.join(input_path, zip_path)

        if File.directory?(filepath)
          build_sub_directory(zip_path, filepath)
        else
          build_file_to_zip(zip_path, filepath)
        end
      end
    end

    def build_sub_directory(zip_path, filepath)
      zip.mkdir(zip_path)
      subdir_entries = get_directory_content(filepath); 
      delete_non_zip_content(subdir_entries)

      write_entries(zip_path, subdir_entries)
    end

    def build_file_to_zip(zip_path, filepath)
      zip.get_output_stream(zip_path) do |file|
        file.puts(File.open(filepath, "rb").read())
      end
    end

end
