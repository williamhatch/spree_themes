# precompiling .js files
Rails.application.config.assets.precompile += %w( spree/backend/codemirror.js spree/backend/ruby.js )

# precompiling .css files
Rails.application.config.assets.precompile += %w( spree/backend/codemirror.css )
