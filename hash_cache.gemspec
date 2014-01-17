# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'hash_cache/version'

Gem::Specification.new do |spec|
  spec.name          = "hash_cache"
  spec.version       = HashCache::VERSION
  spec.authors       = ["Nathan Long"]
  spec.email         = ["nathanmlong@gmail.com"]
  spec.description   = %q{A small collection of hashes that cache}
  spec.summary       = %q{A small collection of hashes that cache}
  spec.homepage      = "https://github.com/nathanl/hash_cache"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec",   "~> 2.14"

end
