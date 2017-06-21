# precompiling .js files
Rails.application.config.assets.precompile += %w( spree/backend/codemirror.js spree/backend/ruby.js )

# precompiling .css files
Rails.application.config.assets.precompile += %w( spree/backend/codemirror.css )

# Loading assets current theme assets path.
Rails.application.config.assets.paths << Rails.root.join('public', 'themes', 'current', 'javascripts')
Rails.application.config.assets.paths << Rails.root.join('public', 'themes', 'current', 'stylesheets')
