source 'https://rubygems.org'

gem 'rails', '4.1.5'
gem 'axlsx_rails'
gem 'html2haml'
gem 'stripe', :git => 'https://github.com/stripe/stripe-ruby'
group :production do
  gem 'rails_12factor'
  gem 'unicorn'
  gem 'skylight'
end

gem 'sass-rails', '~> 4.0.0'
gem 'uglifier', '>= 1.3.0'
gem 'coffee-rails', '~> 4.0.0'
gem 'jquery-rails'
gem 'jquery-turbolinks'

# Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
gem 'turbolinks'
gem "haml"
gem "haml-rails"

group :doc do
  # bundle exec rake doc:rails generates the API under doc/api.
  gem 'sdoc', require: false
end

# gem 'rvm-capistrano'
gem 'capistrano'
gem 'capistrano-rails'
gem 'capistrano-bundler'
gem 'capistrano-rbenv'

group :development do
	gem 'guard-livereload', require: false
  gem "spring-commands-rspec"
end

gem 'pg'
gem 'devise'

group :development, :test do
  gem "rspec-rails"
  gem "factory_girl_rails"
	gem 'rspec-collection_matchers'
end

group :test do
  gem "faker"
  gem "capybara"
  gem "database_cleaner"
  gem "launchy"
  gem "capybara-webkit"
  gem "sqlite3"
  gem "webmock"
  gem 'stripe-ruby-mock', '~> 2.0.0'
end

# Use debugger
# gem 'debugger', group: [:development, :test]
