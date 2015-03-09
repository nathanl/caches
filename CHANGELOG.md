# Change Log
All notable changes to this project will be documented in this file.

## Unreleased

- Nothing

## 0.0.5 - 2015-03-09

### Added

- `Caches::TTL` and `Caches::LRU` support `#stats`, which gives counts of how many cache hits and misses have occurred

## 0.0.4 - 2015-03-03

### Added

- `Caches::TTL` supports `#delete(key)`
- Added a CONTRIBUTING guide
- Benchmarking with Ruby 2.1.3
- `Caches::LRU` can handle `max_keys: 0`

## 0.0.3 - 2014-08-22

Currently have `Caches::TTL` and `Caches::LRU`
