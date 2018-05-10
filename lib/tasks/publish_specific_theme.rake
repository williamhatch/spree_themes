namespace :db do
  ZIP_FILEPATH = File.join('public', 'system', 'spree', 'themes')

  desc "Update selected theme"
  task :publish_specific_theme, [:theme] => [:environment] do |t, args|
    ActiveRecord::Base.transaction do
      filepath = File.open(ZIP_FILEPATH + '/' + args[:theme] + '.zip')
      theme = Spree::Theme.find_or_initialize_by(name: args[:theme])
      theme.template_file = File.open(filepath)
      theme.save(validate: false)
      ZipFileExtractor.new(filepath, theme).extract
      theme.compile
    end

    ActiveRecord::Base.transaction do
      theme = Spree::Theme.find_by(name: args[:theme])
      begin
        theme.publish
      end
    end

  end
end
