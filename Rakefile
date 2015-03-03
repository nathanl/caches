require "bundler/gem_tasks"
require 'rspec/core/rake_task'

task :default => :spec

desc "Run the specs in documentation format"
RSpec::Core::RakeTask.new(:spec) do |t|
  t.rspec_opts = '--format documentation'
end

desc "Run the benchmarks"
RSpec::Core::RakeTask.new(:benchmark) do |t|
  t.rspec_opts = '--format documentation --tag benchmark'
end

task :console do
  require 'irb'
  require 'irb/completion'
  require 'caches/all'
  ARGV.clear
  IRB.start
end

task :default => :spec
