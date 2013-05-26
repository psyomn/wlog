# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'wlog/version'

Gem::Specification.new do |spec|
  spec.name          = "wlog"
  spec.version       = Wlog::VERSION
  spec.authors       = ["psyomn"]
  spec.email         = ["lethaljellybean@gmail.com"]
  spec.description   = %q{Track tasks and time on the command line.}
  spec.summary       = %q{A light ruby script to help track tasks and time}
  spec.homepage      = ""
  spec.license       = "GPL v3.0"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
end
