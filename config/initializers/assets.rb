# Loading assets current theme assets path.

Rails.application.config.assets.paths << Rails.root.join('public', 'vinsol_spree_themes', 'current', 'javascripts')
Rails.application.config.assets.paths << Rails.root.join('public', 'vinsol_spree_themes', 'current', 'stylesheets')
Rails.application.config.assets.paths << Rails.root.join('public', 'assets', 'vinsol_spree_theme')

# precompiling .js files
Rails.application.config.assets.precompile += %w( spree/backend/editor.js
                                                  spree/backend/main.js
                                                  spree/backend/search.js
                                                  spree/backend/theme.js
                                                  *.manifest.js
                                                )

# precompiling .css files
Rails.application.config.assets.precompile += %w( spree/backend/editor.css
                                                  *.manifest.css
                                                )
