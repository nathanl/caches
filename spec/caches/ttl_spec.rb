require          'spec_helper'
require          'fetch_examples'
require_relative '../../lib/caches/ttl'

describe Caches::TTL do

  let(:ttl)         { 0.1 }
  let(:most_of_ttl) { ttl * 0.8 }
  let(:options)     { { ttl: ttl} }
  let!(:cache)   {
    described_class.new(options).tap {|c|
      c[:a] = 'Aravis'
      c[:b] = 'Bern'
      c[:c] = 'Caspian'
    }
  }

  it "can report its size" do
    expect(cache.size).to eq(3)
  end

  it "can delete keys" do
    expect(cache.keys).to eq(%i[a b c])
    expect(cache.size).to eq(3)
    # testing private method
    expect(cache.send(:nodes).length).to eq(3)

    deleted = cache.delete(:b)
    expect(deleted).to eq('Bern')

    expect(cache.keys).to eq(%i[a c])
    expect(cache.size).to eq(2)
    # testing private method
    expect(cache.send(:nodes).length).to eq(2)
  end

  it "remembers cached values before the TTL expires" do
    expect(cache).not_to receive(:delete)
    expect(cache[:c]).to eq('Caspian')
    expect(cache.size).to eq(3)
  end

  it "forgets cached values when a read is attempted after the TTL expires" do
    sleep(ttl)
    expect(cache).to receive(:delete).with(:a).and_call_original
    expect(cache[:a]).to be_nil
    expect(cache.size).to eq(2)

    expect(cache).to receive(:delete).with(:c).and_call_original
    expect(cache[:c]).to be_nil
    expect(cache.size).to eq(1)
  end

  describe "listing keys and values" do

    it "can list them" do
      expect(cache.keys).to eq(%i[a b c])
      expect(cache.values).to eq(%w[Aravis Bern Caspian])
    end

    it "does not check whether they are current" do
      sleep(ttl)
      expect(cache.keys).to eq(%i[a b c])
      expect(cache.values).to eq(%w[Aravis Bern Caspian])
    end

  end

  it "continues returning nil for cached values after the TTL expires" do
    expect(cache[:c]).to eq('Caspian')
    sleep(ttl)
    expect(cache[:c]).to be_nil
    expect(cache[:c]).to be_nil
  end

  it "resets TTL when an item is updated" do
    expect(cache[:c]).to eq('Caspian')
    sleep(most_of_ttl)
    cache[:c] = 'Cornelius'
    sleep(most_of_ttl)
    expect(cache[:c]).to eq('Cornelius')
  end

  it "doesn't reset TTL when an item is accessed" do
    expect(cache[:c]).to eq('Caspian')
    sleep(most_of_ttl)
    expect(cache[:c]).to eq('Caspian')
    sleep(most_of_ttl)
    expect(cache[:c]).to be_nil
  end

  context "when asked to refresh TTL on access" do

    let(:options) { {ttl: ttl, refresh: true} }

    it "keeps values that were accessed before the TTL expired" do
      sleep(most_of_ttl)
      expect(cache[:c]).to eq('Caspian')
      sleep(most_of_ttl)
      expect(cache[:c]).to eq('Caspian')
    end

  end

  include_examples "fetch"

  describe "memoize" do

    it "requires a block" do
      expect{cache.memoize(:c)}.to raise_error(ArgumentError)
    end

    let(:greeting) { 'hi' }

    context "when the key already exists" do

      context "before the TTL is up" do

        it "returns the existing value" do
          expect(cache.memoize(:c) { 'Eustace' } ).to eq('Caspian')
        end

        it "does not calculate the value" do
          expect(greeting).not_to receive(:upcase)
          cache.memoize(:c) { greeting.upcase }
        end

      end

      context "after the TTL is up" do

        it "recalculates the value" do
          expect(cache[:c]).to eq('Caspian')
          sleep(ttl)
          expect(greeting).to receive(:upcase)
          cache.memoize(:c) { greeting.upcase }
        end

        it "returns the calculated value" do
          expect(cache[:c]).to eq('Caspian')
          sleep(ttl)
          expect(cache.memoize(:c) { |key| key.to_s.upcase }).to eq('C')
        end

      end

    end

    context "when the key does not exist" do

      it "calculates the value" do
        expect(greeting).to receive(:upcase)
        cache.memoize(:nonexistent) { greeting.upcase }
      end

      it "returns the value" do
        expect(cache.memoize(:nonexistent) { |key| key.to_s.upcase }).to eq('NONEXISTENT')
      end

      it "does not calculate the value again within the TTL" do
        cache.memoize(:nonexistent) { greeting.upcase }
        sleep(most_of_ttl)
        expect(greeting).not_to receive(:upcase)
        cache.memoize(:nonexistent) { greeting.upcase }
      end

      it "does calculate the value again after the TTL is up" do
        cache.memoize(:nonexistent) { greeting.upcase }
        sleep(ttl)
        expect(greeting).to receive(:upcase)
        cache.memoize(:nonexistent) { greeting.upcase }
      end

    end

  end

  describe "supporting a maximum size" do

    let(:refresh) { false }
    let(:options) { {ttl: ttl, max_keys: 3, refresh: refresh} }

    let!(:cache)   {
      described_class.new(options).tap {|c|
        c[:a] = 'Aravis'
        c[:b] = 'Bern'
      }
    }

    context "when it's not full" do

      it "doesn't evict on insertion" do
        expect(cache.size).to eq(2)
        cache[:c] = 'Caspian'
        expect(cache.size).to eq(3)
      end

    end

    context "when it's full" do

      before :each do
        cache[:c] = 'Caspian'
        expect(cache.size).to eq(3)
      end

      it "evicts the oldest key on insertion" do
        cache[:d] = 'Drinian'
        expect(cache.keys).to eq([:b, :c, :d])
      end

      context "if it was set to refresh on read" do

        let(:refresh) { true }

        it "takes reads into account when deciding what to evict" do
          cache[:a]
          cache[:d] = 'Drinian'
          expect(cache.keys).to eq([:a, :c, :d])
        end

      end

      it "doesn't evict on update" do
        cache[:c] = 'Corin'
        expect(cache.size).to eq(3)
      end

      it "doesn't evict on read" do
        cache[:c]
        expect(cache.size).to eq(3)
      end

    end

  end

  describe "stats" do

    it "can report hits and misses" do
      cache[:a]
      cache[:b]
      cache[:nope]
      expect(cache.stats).to eq(hits: 2, misses: 1, hit_rate: "66.66666666666666%")
    end

  end

  describe "clear" do

    it "clears all cached data" do
      cache.clear
      expect(cache.size).to eq(0)
    end

    it "clears the stats" do
      cache[:a]
      cache[:nope]
      cache.clear
      expect(cache.stats).to eq(hits: 0, misses: 0, hit_rate: "0.0%")
    end

    it "returns the empty cache" do
      id = cache.object_id
      returned = cache.clear
      expect(returned.object_id).to eq(id)
    end

  end

end
