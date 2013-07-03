unless defined?(Motion::Project::Config)
    raise "The drink-menu gem must be required within a RubyMotion project Rakefile."
end

Motion::Project::App.setup do |app|
  Dir.glob(File.join(File.dirname(__FILE__), 'drink-menu/**/*.rb')).each do |file|
    app.files.unshift(file)
  end
end
