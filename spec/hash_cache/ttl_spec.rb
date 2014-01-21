require          'spec_helper'
require          'fetch_examples'
require_relative '../../lib/hash_cache/ttl'

describe HashCache::TTL do

  let(:options) { {} }
  let(:cache)   {
    described_class.new(options).tap {|c|
      c[:c] = 'Caspian'
      c.stub(:current_time).and_return(start_time)
    }
  }

  let(:start_time) { Time.now }
  let(:before_ttl) { start_time + 1800 }
  let(:after_ttl)  { start_time + 3601 }

  it "remembers cached values before the TTL expires" do
    expect(cache[:c]).to eq('Caspian')
    cache.stub(:current_time).and_return(before_ttl)
    expect(cache[:c]).to eq('Caspian')
  end

  it "forgets cached values after the TTL expires" do
    expect(cache[:c]).to eq('Caspian')
    cache.stub(:current_time).and_return(after_ttl)
    expect(cache[:c]).to be_nil
  end

  it "continues returning nil for cached values after the TTL expires" do
    expect(cache[:c]).to eq('Caspian')
    cache.stub(:current_time).and_return(after_ttl)
    expect(cache[:c]).to be_nil
    expect(cache[:c]).to be_nil
  end

  it "resets TTL when an item is updated" do
    cache.stub(:current_time).and_return(before_ttl)
    cache[:c] = 'Cornelius'
    cache.stub(:current_time).and_return(after_ttl)
    expect(cache[:c]).to eq('Cornelius')
  end

  it "doesn't reset TTL when an item is accessed" do
    cache.stub(:current_time).and_return(before_ttl)
    expect(cache[:c]).to eq('Caspian')
    cache.stub(:current_time).and_return(after_ttl)
    expect(cache[:c]).to be_nil
  end

  context "when asked to refresh TTL on access" do

    let(:options) { {refresh: true} }

    it "keeps values that were accessed before the TTL expired" do
      cache.stub(:current_time).and_return(before_ttl)
      expect(cache[:c]).to eq('Caspian')
      cache.stub(:current_time).and_return(after_ttl)
      expect(cache[:c]).to eq('Caspian')
    end

  end

  include_examples "fetch"

  describe "memoize" do

    it "requires a block" do
      expect{cache_memoize(:c)}.to raise_error
    end

    let(:greeting) { 'hi' }

    context "when the key already exists" do

      context "before the TTL is up" do

        it "returns the existing value" do
          expect(cache.memoize(:c) { 'Eustace' } ).to eq('Caspian')
        end

        it "does not calculate the value" do
          cache.stub(:current_time).and_return(before_ttl)
          expect(greeting).not_to receive(:upcase)
          cache.memoize(:c) { greeting.upcase }
        end

      end

      context "after the TTL is up" do

        it "recalculates the value" do
          cache.stub(:current_time).and_return(after_ttl)
          expect(greeting).to receive(:upcase)
          cache.memoize(:c) { greeting.upcase }
        end

        it "returns the calculated value" do
          cache.stub(:current_time).and_return(after_ttl)
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
        cache.stub(:current_time).and_return(before_ttl)
        expect(greeting).not_to receive(:upcase)
        cache.memoize(:nonexistent) { greeting.upcase }
      end

      it "does calculate the value again after the TTL is up" do
        cache.memoize(:nonexistent) { greeting.upcase }
        cache.stub(:current_time).and_return(after_ttl)
        expect(greeting).to receive(:upcase)
        cache.memoize(:nonexistent) { greeting.upcase }
      end

    end

  end

end
