source 'https://rubygems.org'

gem 'chef', '~> 11.16.4'
gem 'rake', '>= 10.2'

group :workflow do
  gem 'berkshelf', '~> 3.2'
  gem 'dogapi'
  gem 'knife-ec2', '~> 0.10.0'
  gem 'eventmachine', '~> 1.0.4'
  gem 'unf'
end

group :development do
  gem 'guard'
  gem 'guard-foodcritic'
  gem 'guard-kitchen'
  gem 'guard-rspec'
  gem 'guard-rubocop'
  gem 'pry'
end

group :ci do
  # style
  gem 'foodcritic', '~> 4.0'
  gem 'rubocop', '~> 0.28.0'
  gem 'rubocop-checkstyle_formatter', require: false

  # unit
  gem 'chefspec', '~> 4.2'

  # integration
  gem 'test-kitchen'
  # awating release of https://github.com/test-kitchen/kitchen-vagrant/pull/126
  gem 'kitchen-vagrant', git: 'https://github.com/test-kitchen/kitchen-vagrant.git', ref: 'a85f2e59832a5dbb1a2f1d03e78e7bd4f68a970d'
end
