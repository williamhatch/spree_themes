namespace :db do
  ZIP_FILEPATH = File.join('public', 'system', 'spree', 'themes')

  desc "Update selected theme"
  task :publish_specific_theme, [:theme] => [:environment] do |t, args|
    ActiveRecord::Base.transaction do
      filepath = File.join(ZIP_FILEPATH + '/' + args[:theme] + '.zip')
      theme = Spree::Theme.find_or_initialize_by(name: args[:theme])
      theme.template_file = File.open(filepath)
      theme.save(validate: false)
      ZipFileExtractor.new(filepath, theme).extract
      theme.compile
      Rails.cache.clear
    end

    ActiveRecord::Base.transaction do
      theme = Spree::Theme.find_by(name: args[:theme])
      begin
        theme.compile
        theme.publish
        Rails.cache.clear
      end
    end

  end
end
