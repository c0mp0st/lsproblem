# -*- encoding: utf-8 -*-
require File.expand_path('../lib/packer/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Stephen Pearson"]
  gem.email         = ["stephen@hp.com"]
  gem.description   = %q{Packer description}
  gem.summary       = %q{Packer summary}
  gem.homepage      = "https://github.com/c0mp0st/packer"

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "packer"
  gem.require_paths = ["lib"]
  gem.version       = Packer::VERSION
  gem.add_dependency('git', '>= 1.2.5')
  gem.add_dependency('trollop', '>= 1.16.2')
  gem.add_dependency('sinatra', '>= 1.3.2')
  gem.add_dependency('thin', '>= 1.4.1')
  gem.add_development_dependency('mocha', '0.12.3')
  gem.add_development_dependency('rack-test', '0.6.1')
end
