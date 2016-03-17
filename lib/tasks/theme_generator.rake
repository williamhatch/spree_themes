require_relative '../../app/services/spree/theme_generator_service'

desc 'Generates a new theme'
task :generate_theme do
  Spree::ThemeGeneratorService.new(ENV['name']).generate
end
