require          'spec_helper'
require          'fetch_examples'
require_relative '../../lib/caches/lru'

describe Caches::LRU do

  let(:options) { {max_keys: 4} }
  let(:cache)   {
    described_class.new(options).tap {|c|
      c[:a] = 'Alambil'
      c[:b] = 'Belisar'
      c[:c] = 'Caspian'
    }
  }

  it "remembers its values" do
    expect(cache[:a]).to eq('Alambil')
    expect(cache[:b]).to eq('Belisar')
    expect(cache[:c]).to eq('Caspian')
  end

  it "can report its size" do
    expect(cache.size).to eq(3)
  end

  it "can grow up to the max size given" do
    cache[:d] = 'Destrier'
    expect(cache.size).to eq(4)
  end

  it "does not grow beyond the max size given" do
    cache[:d] = 'Destrier'
    cache[:e] = 'Erimon'
    expect(cache.size).to eq(4)
  end

  it "drops the least-recently accessed key" do
    cache[:d] = 'Destrier'
    cache[:e] = 'Erimon'
    expect(cache[:a]).to be_nil
  end

  it "counts a read as access" do
    cache[:d] = 'Destrier'
    cache[:a]
    cache[:e] = 'Erimon'
    expect(cache[:a]).to eq('Alambil')
    expect(cache[:b]).to be_nil
  end

  include_examples "fetch"

  describe "memoize" do

    it "requires a block" do
      expect{cache_memoize(:c)}.to raise_error
    end

    let(:greeting) { 'hi' }

    context "when the key already exists" do

      it "does not calculate the value" do
        expect(greeting).not_to receive(:upcase)
        cache.memoize(:c) { greeting.upcase }
      end

    end

    context "when the key has not been set" do

      let(:key) { :nonexistent }

      it "calculates the value" do
        expect(greeting).to receive(:upcase)
        cache.memoize(:nonexistent) { greeting.upcase }
      end

      it "sets the value" do
        cache.memoize(:nonexistent) { greeting.upcase }
        expect(cache[:nonexistent]).to eq(greeting.upcase)
      end

    end

    context "when the key has been dropped" do

      before :each do
        cache[:d] = 'Destrier'
        cache[:e] = 'Erimon'
      end

      it "calculates the value" do
        expect(greeting).to receive(:upcase)
        cache.memoize(:a) { greeting.upcase }
      end

      it "sets the value" do
        cache.memoize(:a) { greeting.upcase }
        expect(cache[:a]).to eq(greeting.upcase)
      end

    end

  end

end

