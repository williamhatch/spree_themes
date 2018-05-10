namespace :db do
  desc "Updates themes and publish first theme"

  THEMES = ['BigShop.zip', 'ClassicWhite.zip']
  ZIP_FILEPATH = File.join('public', 'system', 'spree', 'themes')


  task publish_theme: :environment do
    THEMES.each do |name|
      ActiveRecord::Base.transaction do
        filepath = File.join(ZIP_FILEPATH + '/' + name)

        theme = Spree::Theme.find_or_initialize_by(name: name)
        theme.template_file = File.open(filepath)
        theme.save(validate: false)

        ZipFileExtractor.new(filepath, theme).extract
        theme.compile
        Rails.cache.clear
      end
    end

    ActiveRecord::Base.transaction do
      theme = Spree::Theme.last
      begin
        theme.publish
        Rails.cache.clear
      end
    end
  end
end
