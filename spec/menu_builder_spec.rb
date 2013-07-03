class TestMenu; extend DrinkMenu::MenuBuilder; end

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
    item1 = TestMenu.menuItem :test_item1, title: "Blah"
    item2 = TestMenu.menuItem :test_item2, title: "Blah"

    TestMenu.menu :main_menu, title: "Main" do
      test_item1
      ___
      test_item2
    end

    TestMenu.build!

    TestMenu[:main_menu][:test_item1].should.equal item1
    TestMenu[:main_menu][:test_item2].should.equal item2

    TestMenu[:main_menu][2].isSeparatorItem.should.be.true
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

      Context.new(menu).send :"___"

      puts menu.menuItems.inspect
      menu[1].isSeparatorItem.should.be.true
    end

  end
end
