namespace :db do
  desc "create themes"
  task :create_theme, [:theme_name] => [:environment] do |t, args|
    themes = ['default', args.theme_name]
    themes.each do |theme_name|
      theme = Spree::Theme.find_or_initialize_by(name: theme_name)
      filepath = "#{ Rails.root}/public/system/spree/themes/#{ theme_name }.zip"
      theme.template_file = File.open(filepath)
      theme.save(validate: false)
      theme.compile
    end
    theme = Spree::Theme.find_by(name: args.theme_name)
    theme.update_column(:state, 'published')
  end
end
