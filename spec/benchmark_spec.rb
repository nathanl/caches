require 'spec_helper'
require 'benchmark/ips'
require_relative '../lib/caches/all'
require 'stringio'

describe "benchmarks", benchmark: true do

  # Comment to unmute the output from Benchmark
  before(:all) { $stdout = StringIO.new }
  after(:all)  { $stdout = STDOUT }

  let(:klass) { described_class }

  # These are both somewhat arbitrary and may depend on Ruby version
  # Tested with Ruby 2.1.3
  let(:reasonable_ratio) { 1.1 }
  let(:reasonable_percent_variation) { 30 }

  describe Caches::TTL do

    let!(:small_range) { (1..10) }
    let!(:small_cache) {
      klass.new.tap { |sc| small_range.each {|key| sc[key] = key } }
    }
    let(:big_range) { (1..1_000_000) }
    let(:big_cache) {
      klass.new.tap { |sc| big_range.each {|key| sc[key] = key } }
    }

    let(:very_big_range) { 1..10_000_000 }
    let(:very_big_cache) {
      klass.new.tap { |sc| very_big_range.each { |key| sc[key] = key } }
    }

    it "has constant time reads" do
      big_cache[1] # force creation
      results = {}
      report = Benchmark.ips do |x|
        small_cache_test_keys = small_range.to_a.shuffle.cycle
        big_cache_test_keys   = big_range.to_a.shuffle.cycle
        results[:small] = x.report("reading from small cache") {
          small_cache[small_cache_test_keys.next]
        }
        results[:big]   = x.report("reading from big cache") {
          big_cache[big_cache_test_keys.next]
        }
      end
      small_ips = report.entries.first.ips
      big_ips   = report.entries.last.ips
      expect(big_ips).to be < (small_ips * reasonable_ratio)
    end

    it "has constant time inserts" do
      write_keys = (1..10_000_000).to_a.shuffle.cycle
      report = Benchmark.ips do |x|
        x.report("inserts") { small_cache[write_keys.next] = :a }
      end
      rand_report = report.entries.first

      variance = rand_report.stddev_percentage
      expect(variance).to be < reasonable_percent_variation
    end

    it "has constant time updates" do
      write_keys = small_range.to_a.cycle
      report = Benchmark.ips do |x|
        x.report("updates") { small_cache[write_keys.next] = :a }
      end
      rand_report = report.entries.first

      variance = rand_report.stddev_percentage
      expect(variance).to be < reasonable_percent_variation
    end

    # Using a very big cache here in hopes that, even though IPS does as many
    # deletes as it possibly can during its runtime, it won't finish deleting
    # all the cache keys before it finishes
    it "has constant time deletes" do
      delete_keys = very_big_range.to_a.each
      very_big_cache[1] # force creation
      report = Benchmark.ips do |x|
        x.report("deletes") { very_big_cache.delete(delete_keys.next) }
      end
      rand_report = report.entries.first

      variance = rand_report.stddev_percentage
      expect(variance).to be < reasonable_percent_variation
    end

  end

end
