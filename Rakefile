require "bundler/gem_tasks"
require 'rspec/core/rake_task'

desc "Run the specs in documentation format"
RSpec::Core::RakeTask.new(:spec) do |t|
  t.rspec_opts = '--format documentation'
end

task :default => :spec
