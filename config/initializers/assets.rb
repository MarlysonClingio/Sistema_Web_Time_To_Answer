# Be sure to restart your server when you modify this file.

# Version of your assets, change this if you want to expire all your assets.
Rails.application.config.assets.version = '1.0'

# Add additional assets to the asset load path.
# Rails.application.config.assets.paths << Emoji.images_path
# Add Yarn node_modules folder to the asset load path.
Rails.application.config.assets.paths << Rails.root.join('node_modules')

# Precompile additional assets.
# application.js, application.css, and all non-JS/CSS in the app/assets
# folder are already added.
Rails.application.config.assets.precompile += %w( admins_backoffice.js admins_backoffice.css users_backoffice.js users_backoffice.css admins_devise.css admins_devise.js users_devise.css users_devise.js site.css site.js)
Rails.application.config.assets.precompile += %w( custom.js custom.css user.png admin.png)
