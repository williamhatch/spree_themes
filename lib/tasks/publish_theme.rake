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
        theme.compile
      end
    end

    ActiveRecord::Base.transaction do

      theme = Spree::Theme.last

      path = "/public/vinsol_spree_themes/"
      current_path = path + 'current'
      theme_path =  path + theme.name

      Spree::Theme.published.each(&:draft)

      theme.assets_precompile
      theme.publish

      File.delete(current_path) if File.exist?(current_path)

      # theme.remove_current_theme
      # theme.publish!

      # theme.update(state: 'publish')
      FileUtils.ln_sf(theme_path, current_path)
      AssetsPrecompilerService.new(theme).copy_assets

      theme.remove_cache
      theme.update_cache_timestamp
    end
  end
end
