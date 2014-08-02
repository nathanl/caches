require          'spec_helper'
require          'fetch_examples'
require_relative '../../lib/caches/lu'

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

end
