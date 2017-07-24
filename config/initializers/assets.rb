# Loading assets current theme assets path.

Rails.application.config.assets.paths << Rails.root.join('public', 'vinsol_spree_themes', 'current', 'javascripts')
Rails.application.config.assets.paths << Rails.root.join('public', 'vinsol_spree_themes', 'current', 'stylesheets')
Rails.application.config.assets.paths << Rails.root.join('public', 'vinsol_spree_themes', 'current', 'fonts')
Rails.application.config.assets.paths << Rails.root.join('public', 'assets', 'vinsol_spree_theme')
Rails.application.config.assets.paths << Rails.root.join('public', 'assets', 'preview_vinsol_spree_theme')

# precompiling .js files
Rails.application.config.assets.precompile += %w( spree/backend/editor.js
                                                  spree/backend/main.js
                                                  spree/backend/template.js
                                                  spree/backend/theme.js
                                                  spree/backend/jquery.treemenu.js
                                                  *.manifest.js
                                                )

# precompiling .css files
Rails.application.config.assets.precompile += %w( spree/backend/editor.css
                                                  spree/backend/jquery.treemenu.css
                                                  *.manifest.css
                                                  *.manifest.scss.css
                                                  *.manifest.scss
                                                )
