namespace :db do

  THEMES = ['BigShop', 'ClassicWhite']
  def create_theme(name)
    full_theme_name = "theme-#{name}-3-3-bump"
    Spree::Theme.find_or_create_by(name: full_theme_name, state: 'drafted', template_file_file_name: "#{full_theme_name}.zip")
  end

  desc "Updates themes"
  task upload_themes: :environment do
    THEMES.each do |theme_name|
      theme = create_theme(theme_name)
      ZipFileExtractor.new("public/system/spree/themes/#{theme.template_file_file_name}", theme).extract
    end
    theme = Spree::Theme.second
    theme.compile
  end

  desc "publish theme"
  task publish_theme: :environment do
    theme = Spree::Theme.second
    theme.publish
  end
end
