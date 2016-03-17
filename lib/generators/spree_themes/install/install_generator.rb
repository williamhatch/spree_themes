module SpreeThemes
  module Generators
    class InstallGenerator < Rails::Generators::Base

      class_option :auto_run_migrations, :type => :boolean, :default => false

      def add_migrations
        run 'bundle exec rake railties:install:migrations FROM=spree_themes'
      end

      def run_migrations
        run_migrations = options[:auto_run_migrations] || ['', 'y', 'Y'].include?(ask 'Would you like to run the migrations now? [Y/n]')
        if run_migrations
          run 'bundle exec rake db:migrate'
        else
          puts 'Skipping rake db:migrate, don\'t forget to run it!'
        end
      end

      def load_sample_data
        copy_spree_default_views = ['', 'y', 'Y'].include?(ask 'Would you like to copy spree default views? [Y/n]')
        if copy_spree_default_views
          FileUtils.cp_r(::SpreeThemes::Engine.root.join('generator', 'themes'), Rails.root.join('vendor'))
        end
      end
    end
  end
end
