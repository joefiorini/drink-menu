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

  if ENV['example']
    app.files << Dir["examples/#{ENV['example']}/**/*.rb"]
  end

  app.pods do
    pod 'ReactiveCocoa', '1.8.1'
  end
end
