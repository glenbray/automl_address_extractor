source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby "2.7.0"

gem "rails", "~> 6.0.2", ">= 6.0.2.1"
gem "pg", ">= 0.18", "< 2.0"
gem "puma", "~> 4.3"
gem "sass-rails", ">= 6"
gem "webpacker", "~> 4.0"
gem "turbolinks", "~> 5"

# Reduces boot times through caching; required in config/boot.rb
gem "bootsnap", ">= 1.4.2", require: false

group :development, :test do
  gem "byebug", platforms: [:mri, :mingw, :x64_mingw]
  gem "rspec-rails"
  gem "pry"
  gem "pry-byebug"
  gem "pry-rails"
  gem "dotenv-rails"
  gem "standard"
  gem "faker"
end

group :development do
  gem "listen", ">= 3.0.5", "< 3.2"
  gem "spring"
  gem "spring-watcher-listen", "~> 2.0.0"
  gem "tty-progressbar"
end

gem "tzinfo-data", platforms: [:mingw, :mswin, :x64_mingw, :jruby]
gem "googleauth"
gem "httparty"
gem "http"
gem "activerecord-import"
