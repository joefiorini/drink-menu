# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'drink-menu/version'

Gem::Specification.new do |spec|
  spec.name          = "drink-menu"
  spec.version       = DrinkMenu::VERSION
  spec.authors       = ["Joe Fiorini"]
  spec.email         = ["joe@joefiorini.com"]
  spec.description   = %q{An easy way to define menu items and visually lay out menus for your OSX apps. Uses ReactiveCocoa to provide a nice syntax for responding to menu interactions. Also provides live-binding to collections, which makes keeping menus up-to-date a breeze!}
  spec.summary       = %q{OSX menus - the ruby way}
  spec.homepage      = "https://github.com/joefiorini/drink-menu"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake", "~> 10.0.0"

  spec.add_dependency "motion-cocoapods"
  spec.add_dependency "cocoapods"
end
