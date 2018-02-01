source 'https://rubygems.org'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?("/")
  "https://github.com/#{repo_name}.git"
end

gem 'active_model_serializers'
gem 'api-pagination'
gem 'apitome', git: "https://github.com/jejacks0n/apitome"
gem 'bootstrap'
gem 'bulk_insert'
gem 'coffee-rails', '~> 4.2'
gem 'devise'
gem 'devise_invitable'
gem 'haml-rails'
gem 'jquery-datatables'
gem 'jquery-rails'
gem 'kaminari'
gem 'pg', '~> 0.18'
gem 'puma', '~> 3.7'
gem 'rails', '~> 5.1.4'
gem 'sass-rails', '~> 5.0'
gem 'uglifier', '>= 1.3.0'

group :development, :test do
  gem 'byebug', '~> 9.1', platforms: [:mri, :mingw, :x64_mingw]
  gem 'capybara', '~> 2.13'
  gem 'factory_bot_rails'
  gem 'pry-byebug', '= 3.5.1'
  gem 'rspec_api_documentation', source: "https://rubygems.org"
  gem 'rspec-rails'
  gem 'selenium-webdriver'
end

group :development do
  gem 'listen', '>= 3.0.5', '< 3.2'
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
  gem 'web-console', '>= 3.3.0'
end
