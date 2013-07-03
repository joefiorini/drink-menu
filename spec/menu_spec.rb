describe "creating menus" do


  it "creates an NSMenu instance" do
    menu = DrinkMenu::Menu.new(:test)
    menu.menu.should.be.an.instance_of NSMenu
  end

  it "forwards title to NSMenu instance" do
    menu = DrinkMenu::Menu.menuWithLabel(:test_menu, title: "title")
    menu.title.should.equal "title"
    menu.menu.title.should.equal menu.title
  end

  it "automatically adds NSMenuItem instance to NSMenu" do
    menu = DrinkMenu::Menu.new(:test)
    item = DrinkMenu::MenuItem.itemWithLabel :test_item, title: "Blah"
    menu << item

    menu.itemArray.should.include item.menuItem

  end

  it "sets a unique tag on each menu item as it's added" do
    menu = DrinkMenu::Menu.new(:test)
    item1 = DrinkMenu::MenuItem.itemWithLabel :test_item1, title: "Blah"
    item2 = DrinkMenu::MenuItem.itemWithLabel :test_item2, title: "Diddy"

    menu << item1
    menu << item2

    item1.menuItem.tag.should.equal 1
    item2.menuItem.tag.should.equal 2

  end

  describe "creating menu from collection of objects" do

    class Person
      attr_reader :firstName, :lastName

      def initialize(firstName, lastName)
        @firstName = firstName
        @lastName = lastName
      end

      def fullName
        "#{@firstName} #{@lastName}"
      end

      def inspect
        "<#Person:#{hash} fullName=\"#{fullName}\">"
      end
    end

    before do
      @people = [Person.new("Joe", "Fiorini"), Person.new("Josh", "Walsh")]
      @controller = NSArrayController.alloc.initWithContent(@people)
      @menu = DrinkMenu::Menu.menuWithLabel :test, itemsFromCollection: @controller, titleProperty: :fullName
    end

    it "automatically creates menu items from each item" do
      @menu.itemArray.length.should.equal 2
    end

    it "sets menu item titles using the property specified in titleProperty" do
      @menu.itemArray.each_with_index do |item, idx|
        item.title.should.equal @people[idx].fullName
      end
    end

    it "supports arrays or array controllers"

    it "sets menu item representedObject using the member" do
      @menu.itemArray.each_with_index do |item, idx|
        item.representedObject.should.equal @people[idx]
      end
    end

    it "delegates menu command to menu items" do
      handled = false

      @menu.subscribeToMembers do |(label, _)|
        label.should.equal :test
        handled = true
      end

      @menu[1].command.execute @menu[1].menuItem
      handled.should.be.true
    end

    it "automatically rebuilds the menu to reflect new members" do
      @menu.itemArray.length.should.equal 2
      newPerson = Person.new("Michael", "Bluth")
      @controller.addObject(newPerson)
      @menu.itemArray.length.should.equal 3
      @menu.itemArray.should.any(&->(item){
        item.representedObject == newPerson
      })
    end

    it "sets up a subscriber for the new item" do
      handled = false
      newPerson = Person.new("Lucille", "Two")
      @controller.addObject(newPerson)
      @menu.subscribe newPerson.hash.to_s do |item|
        handled = true
      end
      newItem = @menu[newPerson.hash.to_s]
      newItem.command.execute(newItem)
      handled.should.be.true
    end

    it "allows selecting an item by its member object" do
      handled = false
      @menu.subscribeToMembers do |(_,item)|
        handled = true
        item.representedObject.should.equal @people[0]
      end

      @menu.selectItemByMember @people[0]
      handled.should.be.true
    end

  end

  it "allows looking up menu items by label" do
    menu = DrinkMenu::Menu.new(:test)
    item = DrinkMenu::MenuItem.itemWithLabel :test_item, title: "Blah"

    menu << item

    menu[item.label].should.equal item
  end

  it "allows selecting an item by its label" do
    handled = false
    menu = DrinkMenu::Menu.new(:test)
    item = DrinkMenu::MenuItem.itemWithLabel :test_item, title: "Blah"

    menu << item

    menu.subscribe :test_item do |_|
      handled = true
    end

    menu.selectItem :test_item

    handled.should.be.true
  end

  it "allows looking up menu items by tag" do
    menu = DrinkMenu::Menu.new(:test)
    item = DrinkMenu::MenuItem.itemWithLabel :test_item, title: "Blah"

    menu << item

    menu[1].should.equal item
  end

  it "supports wrapping menu in a status bar item" do
    menu = DrinkMenu::Menu.statusMenuWithLabel :test, title: "S"
    menu.createStatusItem!
    menu.statusItem.should.be.an.instance_of NSStatusItem
    menu.statusItem.highlightMode.should.be.true
    menu.statusItem.title.should.equal "S"
    menu.statusItem.menu.should.equal menu.menu
  end

  it "supports icon for status bar item" do
    image = NSImage.imageNamed "NSMenuRadio"
    menu = DrinkMenu::Menu.statusMenuWithLabel :test, icon: image
    menu.createStatusItem!
    menu.statusItem.image.should.equal image
  end

  it "supports subscribing to menu item commands" do
    called = false

    item = DrinkMenu::MenuItem.itemWithLabel :test_item, title: "Blah"
    menu = DrinkMenu::Menu.new(:test)

    menu << item

    menu.subscribe :test_item do |(label, value)|
      label.should.equal item.label
      value.should.equal item
      called = true
    end

    item.command.execute(item)
    called.should.be.true
  end

end
