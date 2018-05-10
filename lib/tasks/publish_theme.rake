namespace :db do
  desc "Updates themes and publish first theme"

  THEMES = ['BigShop', 'ClassicWhite']
  ZIP_FILEPATH = File.join('public', 'system', 'spree', 'themes')


  task publish_theme: :environment do
    THEMES.each do |name|
      ActiveRecord::Base.transaction do
        theme_name = "theme-#{name}-3-3-bump"
        filepath = File.open(ZIP_FILEPATH + '/' + theme_name + '.zip')

        theme = Spree::Theme.find_or_initialize_by(name: theme_name, state: 'drafted')
        theme.template_file = File.open(filepath)
        theme.save(validate: false)

        ZipFileExtractor.new(filepath, theme).extract
        theme.compile!
      end
    end

    ActiveRecord::Base.transaction do
      theme = Spree::Theme.last
      theme.assets_precompile
      theme.remove_current_theme

      theme.remove_cache
      theme.update_cache_timestamp
      theme.publish!
    end
  end
end
