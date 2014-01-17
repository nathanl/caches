# HashCache

HashCache is a small collection of hashes that cache data.

## Installation

Add this line to your application's Gemfile:

    gem 'hash_cache'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install hash_cache

## Usage

HashCache provides the following classes.

### HashCache::TTL

TTL (Time To Live) remembers values for as many seconds as you tell it. The default is 3600 seconds (1 hours).

```ruby
require 'hash_cache/ttl'

h = HashCache::TTL.new(ttl: 5)
h[:a] = 'aardvark'
h[:a] #=> 'aardvark'
sleep(6)
h[:a] #=> nil
```

If you pass `refresh: true`, reading a value will reset its timer; otherwise, only writing will.

The `memoize` method fetches a key if it exists and isn't expired; otherwise, it calculates the value using the block and saves it.

```ruby
h = HashCache::TTL.new(ttl: 5)

# Runs the block
h.memoize(:a) { |k| calculation_for(k) }

# Returns the previously-calculated value
h.memoize(:a) { |k| calculation_for(k) }

sleep(6)

# Runs the block
h.memoize(:a) { |k| calculation_for(k) }
```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

# Thanks

Original tests were adapted from [volatile_hash](https://github.com/satyap/volatile_hash).
