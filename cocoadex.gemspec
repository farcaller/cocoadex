# -*- encoding: utf-8 -*-
require File.expand_path('../lib/cocoadex/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Delisa Mason"]
  gem.email         = ["iskanamagus@gmail.com"]
  gem.description   = %q{A reference utility for Cocoa APIs}
  gem.summary       = %q{A command-line reference utility for Cocoa APIs.}
  gem.homepage      = "http://kattrali.github.com/cocoadex"

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "cocoadex"
  gem.require_paths = ["lib"]
  gem.version       = Cocoadex::VERSION
  gem.add_development_dependency('bacon')
  gem.add_development_dependency('rdoc')
  gem.add_development_dependency('aruba')
  gem.add_development_dependency('rake','~> 0.9.2')
  gem.add_dependency('methadone', '~>1.2.1')
  # gem.add_dependency('term-ansicolor')
  # gem.add_dependency('sqlite3')
  gem.add_dependency('nokogiri')
end
