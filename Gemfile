source "https://rubygems.org"
ruby ">= 4.0"

gem "bootsnap", require: false
gem "devise"
gem "importmap-rails"
gem "pg", "~> 1.5"
gem "propshaft"
gem "puma", ">= 5.0"
gem "rails", "~> 8.0"
gem "stimulus-rails"
gem "tailwindcss-rails"
gem "turbo-rails"
gem "tzinfo-data", platforms: %i[windows jruby]

group :development, :test do
  gem "debug", platforms: %i[mri windows], require: "debug/prelude"
  gem "factory_bot_rails"
  gem "faker"
  gem "rspec-rails", "~> 7.0"
  gem "rubocop", require: false
  gem "rubocop-factory_bot", require: false
  gem "rubocop-performance", require: false
  gem "rubocop-rails", require: false
  gem "rubocop-rspec", require: false
  gem "rubocop-rspec_rails", require: false
end

group :development do
  gem "brakeman", require: false
  gem "web-console"
end

group :test do
  gem "database_cleaner-active_record"
  gem "rails-controller-testing"
  gem "shoulda-matchers", "~> 7.0"
end
