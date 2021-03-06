# `caches`

`caches` is a Ruby gem, providing a small collection of caches with good performance and hash-like access patterns. Each is named for its cache expiration strategy - when it will drop a key.

[![Build Status](https://travis-ci.org/nathanl/caches.svg?branch=master)](https://travis-ci.org/nathanl/caches)
[![Code Climate](https://codeclimate.com/github/nathanl/caches/badges/gpa.svg)](https://codeclimate.com/github/nathanl/caches)

## Usage

`caches` provides the following classes.

### Caches::TTL

TTL (Time To Live) remembers values for as many seconds as you tell it. The default is 3600 seconds (1 hour). Sub-seconds are supported; the tests will fail if the value is too low for your machine.

```ruby
require 'caches/ttl'

h = Caches::TTL.new(ttl: 0.01)
h[:a] = 'aardvark'
h[:a] #=> 'aardvark'
sleep(0.02)
h[:a] #=> nil
```

#### Initialization Options

- With `refresh: true`, reading a value will reset its timer; otherwise, only writing will.
- With `max_keys: 5`, on insertion, it will evict the oldest item if necessary to keep from exceeding 5 keys.

#### Methods

`keys` and `values` work the same as for a hash. They **do not** check whether each key is current.

`memoize` method fetches a key if it exists and isn't expired; otherwise, it calculates the value using the block and saves it.


```ruby
h = Caches::TTL.new(ttl: 5)

# Runs the block
h.memoize(:a) { |k| calculation_for(k) }

# Returns the previously-calculated value
h.memoize(:a) { |k| calculation_for(k) }

sleep(6)

# Runs the block
h.memoize(:a) { |k| calculation_for(k) }
```

### Caches::LRU

LRU (Least Recently Used) remembers as many keys as you tell it to, dropping the least recently used key on each insert after its limit is reached. (Inserts and reads count as a usage; updates do not.)

```ruby
require 'caches/lru'
h = Caches::LRU.new(max_keys: 3)
h[:a] = "aardvark"
h[:b] = "boron"
h[:c] = "cattail"
h[:d] = "dingo"
puts h[:a] # => nil
```

## Methods Common to All Caches

- `#fetch` works like `Hash#fetch`
- `#memoize` returns the key's value, if any; if not, it gets its return value from the block, and sets the key before it returns
- `#stats` tells how many cache hits and misses have occurred
- `#clear` resets all data and stats

## Installation

Add this line to your application's Gemfile:

    gem 'caches'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install caches

## Contributing

See CONTRIBUTING.md

# Thanks

- Thanks to [FromAToB.com](http://www.fromatob.com) for giving me time to make this
- Thanks to [satyap](https://github.com/satyap); the original specs for `caches` were adapted from [volatile_hash](https://github.com/satyap/volatile_hash).
