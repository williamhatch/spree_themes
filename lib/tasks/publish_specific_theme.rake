namespace :db do
  ZIP_FILEPATH = File.join('public', 'system', 'spree', 'themes')

  desc "Update selected theme"
  task :publish_specific_theme, [:theme] => [:environment] do |t, args|
    theme_name = "theme-#{args[:theme]}-3-3-bump"
    ActiveRecord::Base.transaction do
      filepath = File.open(ZIP_FILEPATH + '/' + theme_name + '.zip')
      theme = Spree::Theme.find_or_initialize_by(name: theme_name, state: 'drafted')
      theme.template_file = File.open(filepath)
      theme.save(validate: false)
      ZipFileExtractor.new(filepath, theme).extract
      theme.compile!
    end

    ActiveRecord::Base.transaction do
      theme = Spree::Theme.find_by(name: theme_name)
      begin
        # theme.assets_precompile
        # theme.remove_current_theme
        # theme.apply_new_theme
        # theme.remove_cache
        # theme.update_cache_timestamp
        theme.publish
      end
    end

  end
end
