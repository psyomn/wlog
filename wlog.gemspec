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
  spec.summary       = \
    "A light ruby script to help track tasks and time"\
    "#{$/}#{$/}"\
    "commit: #{`git log -n1 | head -1 | awk '{print $2}' | cut -b 1-7`}"

  spec.homepage      = "http://github.com/psyomn/wlog"
  spec.license       = "GPL v3.0"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 2.1.4"
  spec.add_development_dependency "rake", "~> 13.0"
  spec.add_development_dependency "rspec", "~> 3.2"
  spec.add_development_dependency 'redcarpet', "~> 3.2"

  spec.add_runtime_dependency "sqlite3", "~> 1.3", "< 1.4"
  spec.add_runtime_dependency 'activerecord', "~> 4.1"
end
