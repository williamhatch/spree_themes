# Loading assets current theme assets path.
#FIXME_AB: we need to change this after we change the theme folder name as vinsol_spree_themes as stated in other file. 
Rails.application.config.assets.paths << Rails.root.join('public', 'themes', 'current', 'javascripts')
Rails.application.config.assets.paths << Rails.root.join('public', 'themes', 'current', 'stylesheets')
Rails.application.config.assets.paths << Rails.root.join('public', 'assets', 'theme')

# precompiling .js files
Rails.application.config.assets.precompile += %w( spree/backend/editor.js
                                                  spree/backend/main.js
                                                  *.manifest.js
                                                )

# precompiling .css files
Rails.application.config.assets.precompile += %w( spree/backend/editor.css
                                                  *.manifest.css
                                                )

#FIXME_AB: consolidate all migrations in single migration. 