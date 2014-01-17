require          'spec_helper'
require_relative '../../lib/hash_cache/lru'

describe HashCache::LRU do

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

  it "has an accessor for keys" do
    expect(cache.keys.count).to eq(3)
  end

  it "can grow up to the max size given" do
    cache[:d] = 'Destrier'
    expect(cache.keys.count).to eq(4)
  end

  it "does not grow beyond the max size given" do
    cache[:d] = 'Destrier'
    cache[:e] = 'Erimon'
    expect(cache.keys.count).to eq(4)
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

end

