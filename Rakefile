# Encoding: utf-8
require 'bundler/setup'
require 'kitchen'

namespace :style do
  require 'rubocop/rake_task'
  desc 'Run Ruby style checks'
  RuboCop::RakeTask.new(:ruby)

  require 'foodcritic'
  desc 'Run Chef style checks'
  FoodCritic::Rake::LintTask.new(:chef)
end

desc 'Run all style checks'
task style: ['style:ruby', 'style:chef', 'food_extra']

desc 'Run Test Kitchen integration tests'
task :integration do
  Kitchen.logger = Kitchen.default_file_logger
  Kitchen::Config.new.instances.each do |instance|
    instance.test(:always)
  end
end

desc 'Build AMI'
task :build_ami do
  sh 'rm -rf vendor/'
  sh 'berks vendor vendor/cookbooks; packer build packer/build.json'
end

desc 'Run extra Foodcritic rulesets'
task :food_extra do
  sh 'if [ \'$(ls -A foodcritic/)\' ]; then bundle exec foodcritic -f any -I foodcritic/* .; fi'
end

require 'rspec/core/rake_task'
desc 'Run ChefSpec unit tests'
RSpec::Core::RakeTask.new(:spec)

# The default rake task should just run the fast tests.
task default: ['style', 'spec']

begin
  require 'kitchen/rake_tasks'
  Kitchen::RakeTasks.new
  rescue LoadError
    puts '>>>>> Kitchen gem not loaded, omitting tasks' unless ENV['CI']
end
