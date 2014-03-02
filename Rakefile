#!/usr/bin/env rake
require 'bundler'
Bundler::GemHelper.install_tasks
Bundler.setup

desc 'Default: run specs.'
task default: :spec

begin
  require 'rspec/core/rake_task'
  desc 'Run specs'
  RSpec::Core::RakeTask.new

  require 'yard'
  desc 'Generate API docs'
  YARD::Rake::YardocTask.new

  require 'rubocop/rake_task'
  desc 'Check against Ruby style guide'
  Rubocop::RakeTask.new
rescue LoadError
end
