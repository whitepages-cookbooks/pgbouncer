#!/usr/bin/env rake

desc "Runs foodcritic linter"

task :foodcritic do
   puts "Running foodcritic..."
   puts `foodcritic --epic-fail any ./`
   puts "...complete"
end

task :default => 'foodcritic'