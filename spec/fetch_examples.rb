shared_examples "fetch" do

  it "returns the value if an existing key is accessed" do
    expect(cache.fetch(:c)).to eq('Caspian')
  end

  it "raises an error if a missing key is accessed" do
    expect{cache.fetch(:nonexistent)}.to raise_error(KeyError)
  end

  it "uses a default value if one is supplied" do
    expect(cache.fetch(:nonexistent, 'hi')).to eq('hi')
  end

  it "gets its default from a block if one is supplied" do
    expect(cache.fetch(:nonexistent) { |key| key.to_s.upcase }).to eq('NONEXISTENT')
  end

  it "uses the immediate value if both it and the block are supplied" do
    expect(cache.fetch(:nonexistent, 'hi') { |key| key.to_s.upcase }).to eq('hi')
  end

end

