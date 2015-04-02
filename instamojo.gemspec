# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'instamojo/version'

Gem::Specification.new do |spec|
  spec.name          = "instamojo"
  spec.version       = Instamojo::VERSION
  spec.authors       = ["Dinesh Yadav"]
  spec.email         = ["dinesh@codecrux.com"]

  if spec.respond_to?(:metadata)
    spec.metadata['allowed_push_host'] = "TODO: Set to 'http://mygemserver.com' to prevent pushes to rubygems.org, or delete to allow pushes to any server."
  end

  spec.summary       = "Ruby library for Instamojo API"
  spec.description   = "Create links and payments into your ruby application."
  spec.homepage      = "https://github.com/codecrux/instamojo-ruby"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]
  
  spec.add_dependency "excon", "~> 0.45"
  
  spec.add_development_dependency "bundler", "~> 1.8"
  spec.add_development_dependency "rake", "~> 10.0"
  
end
