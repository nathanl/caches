# Change Log
All notable changes to this project will be documented in this file.

## Unreleased

- Small bugfix: in TTL, "refresh on read" also puts key last in line for eviction in case the cache gets too full

## 0.0.7 - 2015-03-09

- `#clear` method clears a cache's data and stats
- Bugfix for `#stats`: 0 hits and 0 misses is `0%`, not `NaN`

## 0.0.6 - 2015-03-09

- Stats include a percentage

## 0.0.5 - 2015-03-09

### Added

- `#stats` method gives counts of how many cache hits and misses have occurred

## 0.0.4 - 2015-03-03

### Added

- `Caches::TTL` supports `#delete(key)`
- Added a CONTRIBUTING guide
- Benchmarking with Ruby 2.1.3
- `Caches::LRU` can handle `max_keys: 0`

## 0.0.3 - 2014-08-22

Currently have `Caches::TTL` and `Caches::LRU`
