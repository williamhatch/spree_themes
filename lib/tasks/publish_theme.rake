namespace :db do
  desc "Updates themes and publish first theme"

  THEMES = ['BigShop', 'ClassicWhite']
  ZIP_FILEPATH = File.join('public', 'system', 'spree', 'themes')


  task publish_theme: :environment do
    THEMES.each do |name|
      ActiveRecord::Base.transaction do
        filepath = File.open(ZIP_FILEPATH + '/' + name + '.zip')

        theme = Spree::Theme.find_or_initialize_by(name: name)
        theme.template_file = File.open(filepath)
        theme.save(validate: false)

        ZipFileExtractor.new(filepath, theme).extract
        theme.compile
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
