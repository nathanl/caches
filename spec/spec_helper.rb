require 'rubygems'
require 'bundler/setup'

RSpec.configure do |config|
  config.order = :random
  config.filter_run_excluding benchmark: true
end
