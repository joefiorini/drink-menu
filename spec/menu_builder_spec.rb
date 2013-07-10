class TestMenu; extend DrinkMenu::MenuBuilder; end
class TestMenu2; include DrinkMenu::MenuBuilder; end

describe "sugar for creating menus" do

  it "supports defining menu items" do
    menuItem = TestMenu.menuItem :create_site, title: 'Create Site'
    menuItem.label.should.equal :create_site
    menuItem.title.should.equal 'Create Site'
  end

  it "supports defining menu items with a block" do
    menuItem = TestMenu.menuItem :create_site do |item|
      item.title = 'Progress Item'
    end

    menuItem.title.should.equal 'Progress Item'
  end

  it "builds gives access to menu instance" do
    TestMenu.menuItem :create_site, title: 'Create Site'
    TestMenu.menu :main_menu, title: "Main"
    menu = TestMenu[:main_menu]
    menu.should.be.an.instance_of DrinkMenu::Menu
  end

  it "allows creating a top-level menu" do
    menu = TestMenu.menu :main_menu, title: "Blah"
    menu.menu.should.be.an.instance_of NSMenu
    menu.title.should.equal "Blah"
  end

  it "allows creating a status bar menu item" do
    menu = TestMenu.statusBarMenu :main_menu, title: "B"
    menu.statusItemTitle.should.equal "B"

    image = NSImage.imageNamed "NSMenuRadio"
    menu = TestMenu.statusBarMenu :main_menu, icon: image
    menu.statusItemIcon.should.equal image
  end

  it "evaluates menu's block to add items to menu" do
    builder = TestMenu2.new
    item1 = builder.menuItem :test_item1, title: "Blah"
    item2 = builder.menuItem :test_item2, title: "Blah"

    builder.menu :main_menu, title: "Main" do
      test_item1
      ___
      test_item2
    end

    builder.build!

    builder[:main_menu][:test_item1].should.equal item1
    builder[:main_menu][:test_item2].should.equal item2

    builder[:main_menu][2].isSeparatorItem.should.be.true
  end

  it "supports generating an NSApp's mainMenu items" do
    builder = TestMenu2.new
    testItem1 = builder.menuItem :test_item1, title: "Blah 1"
    testItem2 = builder.menuItem :test_item2, title: "Blah 2"

    menu1 = builder.mainMenu :menu1, title: "Menu 1" do
      test_item1
    end

    menu2 = builder.mainMenu :menu2, title: "Menu 2" do
      test_item2
    end

    builder.build!

    mainMenu = NSApp.mainMenu

    menuItem = mainMenu.itemArray[0]
    puts "menu1 title: #{menu1.title.inspect}"
    puts "menuItem title: #{menuItem.title.inspect}"
    menuItem.title.should.equal menu1.title
    menuItem.submenu.title.should.equal menu1.title
    menuItem.submenu.itemArray[0].title.should.equal("Blah 1")

    menuItem = mainMenu.itemArray[1]
    menuItem.title.should.equal(menu2.title)
    menuItem.submenu.title.should.equal menu2.title
    menuItem.submenu.itemArray[0].title.should.equal("Blah 2")
  end

  describe "builder's context class" do

    Context = DrinkMenu::MenuBuilder::Context

    it "adds item to menu by calling method named after item's label" do
      menu = DrinkMenu::Menu.new(:test)
      item = DrinkMenu::MenuItem.itemWithLabel :test_item, title: "Blah"
      context = Context.new(menu, {test_item: item})

      menu[:test_item].should.be.nil

      context.test_item

      menu[:test_item].should.equal item
    end

    it "creates separators from ___" do
      menu = DrinkMenu::Menu.new(:test)

      menu[1].should.be.nil

      Context.new(menu).__send__ :"___"

      menu[1].isSeparatorItem.should.be.true
    end

  end
end
