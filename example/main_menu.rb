class MainMenu
  extend DrinkMenu::MenuBuilder

  menuItem :quit do |item|
    item.title = 'Quit'
    item.keyEquivalent = 'q'
  end

  menuItem :open do |item|
    item.title = 'Open'
    item.keyEquivalent = 'o'
  end

  menuItem :new, title: 'New'

  menuItem :close do |item|
    item.title = 'Close'
    item.keyEquivalent = 'w'
  end

  mainMenu :app, title: 'Blah' do
    quit
  end

  mainMenu :file, title: 'File'  do
    new
    open
    ___
    close
  end

end
