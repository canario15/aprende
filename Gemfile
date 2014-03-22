source 'https://rubygems.org'

ruby '2.0.0'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '4.0.0'

gem 'devise'
gem 'omniauth-facebook'

gem "therubyracer"
gem "less-rails" #Sprockets (what Rails 3.1 uses for its asset pipeline) supports LESS
gem 'twitter-bootstrap-rails', :git => 'git://github.com/seyhunak/twitter-bootstrap-rails.git'
gem "paperclip", "~> 3.0"
gem "ransack"

# PDF
gem 'prawn'
gem 'prawn_rails'

group :development, :test do
  # Use sqlite3 as the database for Active Record
  gem 'sqlite3'
  gem 'rspec-rails', '~> 3.0.0.beta'
end

group :test do
  gem 'database_cleaner'
  gem 'machinist', '>= 2.0.0.beta2'
  gem 'guard-rspec'
  gem 'capybara', git: 'git://github.com/jnicklas/capybara.git'
  gem 'capybara-webkit', git: 'git://github.com/thoughtbot/capybara-webkit.git'
  gem 'selenium-webdriver'
  gem 'shoulda-matchers'
end

# Use SCSS for stylesheets
gem 'sass-rails', '~> 4.0.0'
gem 'less'

# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'

# Use CoffeeScript for .js.coffee assets and views
gem 'coffee-rails', '~> 4.0.0'

# See https://github.com/sstephenson/execjs#readme for more supported runtimes
# gem 'therubyracer', platforms: :ruby

# Use jquery as the JavaScript library
gem 'jquery-rails'
gem 'chosen-rails'

# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 1.2'

group :doc do
  # bundle exec rake doc:rails generates the API under doc/api.
  gem 'sdoc', require: false
end

# Use ActiveModel has_secure_password
# gem 'bcrypt-ruby', '~> 3.0.0'

# Use unicorn as the app server
# gem 'unicorn'

# Use Capistrano for deployment
# gem 'capistrano', group: :development

# Use debugger
gem 'byebug', group: [:development, :test]

gem 'ckeditor_rails'
gem 'whenever', require: false