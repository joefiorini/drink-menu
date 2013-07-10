class AppDelegate

  def applicationDidFinishLaunching(notification)
    MainMenu.build!

    MainMenu[:app].subscribe :quit do |_|
      NSApp.terminate(self)
    end

    MainMenu[:file].subscribe :new do |_|
      puts "new"
    end

    MainMenu[:file].subscribe :close do |_|
      puts "close"
    end

    MainMenu[:file].subscribe :open do |_|
      puts "open"
    end

  end

end
