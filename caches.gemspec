# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'caches/version'

Gem::Specification.new do |spec|
  spec.name          = "caches"
  spec.version       = Caches::VERSION
  spec.authors       = ["Nathan Long"]
  spec.email         = ["nathanmlong@gmail.com"]
  spec.description   = %q{A small collection of caches with good performance and hash-like access patterns}
  spec.summary       = %q{Caches with hash-like access}
  spec.homepage      = "https://github.com/nathanl/caches"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec",   "~> 3.3"

  spec.add_development_dependency "benchmark-ips",  "~> 2.0"
end
