# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'sinatra/version'

Gem::Specification.new do |spec|
  spec.name          = "sinatra-log"
  spec.version       = Sinatra::Logger::VERSION
  spec.authors       = ["Shaw Vrana"]
  spec.email         = ["shaw@vranix.com1"]
  spec.description   = %q{A logger for Sinatra}
  spec.summary       = %q{}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(spec)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec", "~> 2.0"
  spec.add_development_dependency "rspec-its"
  spec.add_development_dependency "timecop"

  spec.add_dependency "log4r"
end
