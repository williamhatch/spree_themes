# Loading assets current theme assets path.
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
