source 'https://rubygems.org'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 4.2.11'

# Require up to date versions of the following.
gem "rack", ">= 1.6.11"
gem "rails-html-sanitizer", ">= 1.0.4"
gem "ffi", ">= 1.9.24"
gem "nokogiri", ">= 1.8.5"
gem "sprockets", "< 3.0"
gem "sprockets-rails", "< 3.0"

# Use SCSS for stylesheets
gem 'sass-rails', '~> 5.0'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'
# Use CoffeeScript for .coffee assets and views
# gem 'coffee-rails', '~> 4.1.0'
# See https://github.com/rails/execjs#readme for more supported runtimes
# gem 'therubyracer', platforms: :ruby

# Use jquery as the JavaScript library
gem 'jquery-rails'

# Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
gem 'turbolinks'

# turbolinks breaks things like $(document).ready(), jquery-turbolinks unbreaks them
gem 'jquery-turbolinks'

# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.0'
# bundle exec rake doc:rails generates the API under doc/api.
gem 'sdoc', '~> 0.4.0', group: :doc

# Use Postgres as the database for Active Record
gem 'pg', '~> 0.21'

gem 'httparty'

gem 'bootstrap-sass', '~> 3.4'
gem 'font-awesome-sass', '~> 4.5.0'

gem "omniauth", "~> 1.9.2"
gem "omniauth-rails_csrf_protection"
gem "omniauth-github"

# Authorization framework
gem "cancancan"

# Epic Editor for markdown previewing
gem "epic-editor-rails"

# For using Postgres-specific DB features
gem "schema_plus_core", "~> 1.0.2"
gem "schema_plus_enums"

group :production do
  gem 'rails_12factor'
  gem 'rdoc', '~> 4.3'
end

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'pry-byebug'
  gem 'pry-rescue'

  gem 'better_errors'

  gem 'dotenv-rails'
end

group :development do
  # Access an IRB console on exception pages or by using <%= console %> in views
  gem 'web-console', '>= 3.3.0'

  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
end
