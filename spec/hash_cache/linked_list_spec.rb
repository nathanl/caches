require          'spec_helper'
require_relative '../../lib/hash_cache/linked_list'

describe HashCache::LinkedList do

  let(:list) { described_class.new('lemur') }

  it "can convert itself to an array" do
    expect(list.to_a).to eq(['lemur'])
  end

  it "can append an item" do
    list.append('wombat')
    expect(list.to_a).to eq(['lemur', 'wombat'])
  end

  it "can prepend an item" do
    list.prepend('vole')
    expect(list.to_a).to eq(['vole', 'lemur'])
  end

  context "when there's more than one item" do

    let(:list) {
      list = described_class.new('lemur')
      list.append('muskrat')
      list
    }

    it "can pop the last item" do
      expect(list.pop).to eq('muskrat')
      expect(list.to_a).to eq(['lemur'])
    end

    it "can pop the first item" do
      expect(list.lpop).to eq('lemur')
      expect(list.to_a).to eq(['muskrat'])
    end

  end

end
