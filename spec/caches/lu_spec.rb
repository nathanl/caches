require          'spec_helper'
require          'fetch_examples'
require_relative '../../lib/caches/lu'

describe Caches::LU do

  it "stores each value in a datum"

  it "creates a new datum when a key is written"

  it "uses the datum when a key is read"

  it "keeps a list of keys, sorted by utility"

  it "moves a key up in the list as its utility increases"

  it "has a maximum number of keys"

  it "drops the least useful key on insertion to avoid exceeding its max keys"

end

describe Caches::LU::Datum do

  let(:value)      { "muffins" }
  let(:created_at) { Time.new(2014, 8, 1) }
  let(:datum)      { described_class.new(value, created_at) }

  it "knows its value" do
    expect(datum.value).to eq("muffins")
  end

  it "knows when it was created" do
    expect(datum.created_at).to eq(created_at)
  end

  it "knows how many times it has been used" do
    expect(datum.uses).to eq(0)
    val = datum.use
    expect(val).to eq(value)
    expect(datum.uses).to eq(1)
  end

  it "can calculate its utility" do
    datum.use
    allow(datum).to receive(:current_time).and_return(created_at + 2)
    expect(datum.utility).to eq(0.5)
  end

  describe "comparison to another datum" do

    let(:datum2) { described_class.new(value, created_at) }

    it "is by utility" do
      datum.use
      expect(datum > datum2).to be_true
      2.times { datum2.use }
      expect(datum2 > datum).to be_true
    end

  end

end
