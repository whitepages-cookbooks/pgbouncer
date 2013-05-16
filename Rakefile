require 'rubygems'
require 'bundler'
Bundler.setup

require 'chef_zero/server'

def shell_output(cmd)
  IO.popen(cmd) do |buffer|
    buffer.each { |line| puts line }
  end
end

desc "Runs foodcritic linter"

task :foodcritic do
  puts "Running foodcritic..."
  puts `foodcritic --epic-fail any ./`
  puts "...complete"
end

task :default => 'foodcritic'

desc "Runs spec tests"

task :spec do
  puts 'Running rspec...'
  puts `rspec spec/`
  puts '...complete'
end


namespace :chef_zero do
  desc "start up a chef_zero server"
  task :start do
    puts "starting chef-zero server at 0.0.0.0:8889"

    @server = ChefZero::Server.new(:host => '0.0.0.0', :port => 8889)
    @server.start_background

    puts "chef-zero started"
  end

  desc "stop a previously started chef_zero server"
  task :stop do
    puts "stopping chef-zero"
    @server.stop if @server
    puts "stopped"
  end

  desc "start a server, wait for enter, stops the server"
  task :run do
    Rake::Task['chef_zero:start'].invoke
    print "Press Enter to stop..."
    $stdin.gets.chomp
    Rake::Task['chef_zero:stop'].invoke
  end
end

namespace :berks do
  desc "upload cookbooks via berkshelf to your chef_zero server"
  task :upload do
    puts "using berkshelf to upload cookbooks"
    shell_output "berks upload --config=./test/config.json"
    puts "complete"
  end

  desc "validates that the berkshelf cookbooks are on the chef_zero server"
  task :validate do
    puts "validating the chef_zero instance"
    valid = `cd test; knife cookbook list --key .chef/test.pem | grep pgbouncer | wc -l; cd ..`
    valid = valid.gsub(/\s+/,"").to_i
    if valid == 0
       puts "WTF?!?"
    else
       puts "You're g2g"
    end
     
    puts "...done"
  end

  desc "tests berkshelf"
  task :test do
    puts "testing"
    Rake::Task['chef_zero:start'].invoke
    Rake::Task['berks:upload'].invoke
    Rake::Task['berks:validate'].invoke
    Rake::Task['chef_zero:stop'].invoke
  end
end

namespace :vagrant do
  desc "starts up a vagrant instance"
  task :up do
    puts "spinning up vagrant host"
    shell_output "cd test; vagrant up; cd .."
    puts "...complete"
  end

  task :halt do
    puts "Halting vagrant default instance..."
    shell_output "cd test; vagrant halt; cd .."
    puts "...complete"
  end

  task :destroy do
    puts "Destroying vagrant default instance..."
    shell_output "cd test; vagrant destroy --force; cd .."
    puts "...complete"
  end
end

desc "Spins up a chef-zero server, deploys the cookbook via berkshelf and sets up a vagrant host to fetch the cookbook"
task :vagrant_startup do
  puts "starting up"
  Rake::Task['chef_zero:start'].invoke
  Rake::Task['berks:upload'].invoke
  Rake::Task['vagrant:up'].invoke
  Rake::Task['chef_zero:stop'].invoke
end