# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'snowagent/version'

Gem::Specification.new do |spec|
  spec.name          = "snowagent"
  spec.version       = SnowAgent::VERSION
  spec.authors       = ["Alexey Vakhov", "Artyom Keydunov"]
  spec.email         = ["artyom.keydunov@gmail.com"]
  spec.summary       = %q{Send metrics to snowman}
  spec.description   = %q{Send metrics to snowman}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency "rails"
  spec.add_development_dependency "bundler", "~> 1.7"
  spec.add_development_dependency "rake", "~> 10.0"
end
