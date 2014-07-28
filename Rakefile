require "bundler/gem_tasks"
require 'rspec/core/rake_task'

desc "Run the specs in documentation format"
RSpec::Core::RakeTask.new(:spec) do |t|
  t.rspec_opts = '--format documentation'
end

task :console do
  require 'irb'
  require 'irb/completion'
  require 'hash_cache/all'
  ARGV.clear
  IRB.start
end

task :default => :spec
