namespace :db do

  desc 'Sync theme templates with database. Need to pass theme name to sync as environment variable THEME_NAME.'
  task sync_templates: :environment do

    begin
      
    raise puts 'Environment variable THEME_NAME not found, pass theme name as environment variable.' unless ENV['THEME_NAME']
      
      INVALID_DIRECTORIES = ['.', '..', 'precompiled_assets']

      theme = Spree::Theme.where(name: ENV['THEME_NAME']).first
      THEME_PATH = File.join('public', 'vinsol_spree_themes', theme.name)

      @filepaths_arr = []

      def get_filepaths(path, name=nil)
        Dir.foreach(path) do |entry|
          next if INVALID_DIRECTORIES.include? entry

          full_path = File.join(path, entry)

          if File.directory?(full_path)
            get_filepaths(full_path, entry)
          else
            @filepaths_arr << full_path
          end
        end
        return @filepaths_arr
      end

      get_filepaths(THEME_PATH)

      puts "############################## DB Sync started for theme #{ theme.name } ##############################"

      @filepaths_arr.each do |filepath|
        begin
          puts "*************************** Syncing file #{ filepath } ***************************"
          TemplateGeneratorService.new(filepath, theme).generate
        rescue Exception => e
          puts "#{ e.message }"
        end
      end

    end
  end
end
