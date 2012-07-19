# -*- encoding: utf-8 -*-
require File.expand_path('../lib/cocoadex/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Delisa Mason"]
  gem.email         = ["iskanamagus@gmail.com"]
  gem.description   = %q{A reference utility for Cocoa APIs}
  gem.summary       = %q{A command-line reference utility for Cocoa APIs.}
  gem.homepage      = "http://kattrali.github.com/cocoadex"

  gem.name          = "cocoadex"
  gem.require_paths = ["lib"]
  gem.version       = Cocoadex::VERSION
  gem.add_development_dependency('bacon')
  gem.add_development_dependency('rdoc')
  gem.add_development_dependency('aruba')
  gem.add_development_dependency('rake','~> 0.9.2')
  gem.add_dependency('methadone', '~>1.2.1')
  gem.add_dependency('term-ansicolor')
  # gem.add_dependency('sqlite3')
  gem.add_dependency('bri')
  gem.add_dependency('nokogiri')
  gem.files = %W{
    Gemfile
    LICENSE
    LICENSE.txt
    readme.md
    bin/cocoadex
    data/_store
    lib/cocoadex.rb
    lib/cocoadex/keyword.rb
    lib/cocoadex/parser.rb
    lib/cocoadex/templates.rb
    lib/cocoadex/version.rb
    lib/cocoadex/models/class.rb
    lib/cocoadex/models/docset.rb
    lib/cocoadex/models/element.rb
    lib/cocoadex/models/entity.rb
    lib/cocoadex/models/method.rb
    lib/cocoadex/models/property.rb
    lib/ext/nil.rb
  }
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
end
