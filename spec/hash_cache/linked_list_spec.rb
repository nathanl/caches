require          'spec_helper'
require_relative '../../lib/caches/linked_list'

describe Caches::LinkedList do

  let(:empty_list) { described_class.new }
  let(:list)       { described_class.new('lemur') }
  let(:node_class) { Caches::LinkedList::Node }

  it "can convert itself to an array of values" do
    expect(list.to_a).to eq(['lemur'])
  end

  describe '#append' do

    it "adds an item to the end" do
      list.append('wombat')
      expect(list.to_a).to eq(['lemur', 'wombat'])
    end

    it "returns a Node" do
      node = list.append('wombat')
      expect(node).to be_a(node_class)
    end

    it "sets up the list correctly if it was empty to start with" do
      empty_list.append('jimmy')
      expect{empty_list.prepend('jammy')}.not_to raise_error
    end

  end

  describe "#prepend" do

    it "adds an item to the beginning" do
      list.prepend('vole')
      expect(list.to_a).to eq(['vole', 'lemur'])
    end

    it "returns a Node" do
      node = list.prepend('vole')
      expect(node).to be_a(node_class)
    end

    it "sets up the list correctly if it was empty to start with" do
      empty_list.prepend('jimmy')
      expect{empty_list.append('jammy')}.not_to raise_error
    end

  end

  it "knows its length" do
    expect(list.length).to eq(1)
    list.append('wombat')
    list.prepend('vole')
    expect(list.length).to eq(3)
  end

  describe "#move_to_head" do

    context "when the argument is a Node" do

      it "makes it the new head" do
        list.append('mittens')
        node = list.append('cozy')
        list.move_to_head(node)
        expect(list.to_a).to eq(%w[cozy lemur mittens])
      end

    end

    context "when the argument is not a Node" do

      it "raises an error" do
        list.append('cozy')
        expect{list.move_to_head('super duper')}.to raise_error(Caches::LinkedList::InvalidNode)
      end

    end

  end

  context "when there's more than one item" do

    let(:list) {
      list = described_class.new('lemur')
      list.append('muskrat')
      list
    }

    describe "#pop" do

      it "removes the last item" do
        list.pop
        expect(list.to_a).to eq(['lemur'])
      end

      it "returns a node" do
        expect(list.pop).to be_a(node_class)
      end

    end


    describe "#lpop" do

      it "removes the first item" do
        list.lpop
        expect(list.to_a).to eq(['muskrat'])
      end

      it "returns a node" do
        expect(list.lpop).to be_a(node_class)
      end

    end

  end

end
