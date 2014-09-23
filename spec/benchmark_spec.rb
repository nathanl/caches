require 'spec_helper'
require 'benchmark/ips'
require_relative '../lib/caches/all'
require 'stringio'

describe "benchmarks", benchmark: true do

  # Commnet to unmute the output from Benchmark
  before(:all) { $stdout = StringIO.new }
  after(:all)  { $stdout = STDOUT }

  let(:klass) { described_class }
  let(:reasonable_variation) { 1.1 }

  describe Caches::TTL do

    let!(:small_range) { (1..10) }
    let!(:small_cache) {
      klass.new.tap { |sc| small_range.each {|key| sc[key] = key } }
    }
    let!(:big_range) { (1..100_000) }
    let!(:big_cache) {
      klass.new.tap { |sc| big_range.each {|key| sc[key] = key } }
    }

    it "has constant time reads" do
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
      expect(big_ips).to be < (small_ips * reasonable_variation)
    end

  end

end
