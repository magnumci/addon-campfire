# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'magnum/addons/campfire/version'

Gem::Specification.new do |spec|
  spec.name          = "magnum-addon-campfire"
  spec.version       = Magnum::Addons::Campfire::VERSION
  spec.authors       = ["Dan Sosedoff"]
  spec.email         = ["dan.sosedoff@gmail.com"]
  spec.description   = %q{Campfire notifier addon for Magnum CI}
  spec.summary       = %q{Campfire notifier addon for Magnum CI}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency "hashr",   "~> 0"
  spec.add_dependency "faraday", "~> 0.8"
  spec.add_dependency "json",    "~> 1.8"

  spec.add_development_dependency "bundler",   "~> 1.3"
  spec.add_development_dependency "rake",      "~> 10.0"
  spec.add_development_dependency "rspec",     "~> 2.13"
  spec.add_development_dependency "simplecov", "~> 0.7"
  spec.add_development_dependency "webmock",   "~> 1.2"
end
