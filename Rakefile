require "bundler/gem_tasks"
$:.unshift("/Library/RubyMotion/lib")

if ENV['platform'] == 'osx'
    require 'motion/project/template/osx'
else
  raise "The drink-menu gem must be used within an OSX project."
end

Bundler.setup
Bundler.require

require 'motion-cocoapods'

Motion::Project::App.setup do |app|
  app.name = 'drink-menu'
  app.identifier = 'com.densitypop.drink-menu'
  app.specs_dir = "spec/"

  app.files << Dir["example/**/*.rb"] if ENV['example']

  app.pods do
    pod 'ReactiveCocoa'
  end
end
