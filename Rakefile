require 'bundler'
Bundler::GemHelper.install_tasks

require 'rspec/core/rake_task'
require 'spree/testing_support/extension_rake'
require_relative 'app/services/spree/theme_generator_service'

RSpec::Core::RakeTask.new

task :default do
  if Dir["spec/dummy"].empty?
    Rake::Task[:test_app].invoke
    Dir.chdir("../../")
  end
  Rake::Task[:spec].invoke
end

desc 'Generates a dummy app for testing'
task :test_app do
  ENV['LIB_NAME'] = 'spree_themes'
  Rake::Task['extension:test_app'].invoke
end

desc 'Generates a new theme'
task :generate_theme do
  Spree::ThemeGeneratorService.new(ENV['name']).generate
end
