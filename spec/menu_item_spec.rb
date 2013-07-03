describe "creating menu items" do

  it "keeps the title and label" do
    m = DrinkMenu::MenuItem.itemWithLabel :create_site, title: 'Create Site'
    m.label.should.equal :create_site
    m.title.should.equal 'Create Site'
  end

  it "allows passing a block for further configuration" do
    m = DrinkMenu::MenuItem.itemWithLabel :export do |item|
      item.title = 'Export...'
    end

    m.label.should.equal :export
    m.title.should.equal 'Export...'
  end

  it "has an instance of NSMenuItem" do
    m = DrinkMenu::MenuItem.itemWithLabel :create_site, title: 'Create Site'
    m.menuItem.should.be.a.instance_of NSMenuItem
  end

  it "delegates NSMenuItem methods to NSMenuItem instance" do
    m = DrinkMenu::MenuItem.itemWithLabel :create_site, title: 'Create Site'
    m.enabled = false
    m.tag = 1
    m.image = NSImage.imageNamed "NSMenuRadio"
    m.state = NSOnState

    m.menuItem.title.should.equal m.title
    m.menuItem.isEnabled.should.equal m.isEnabled
    m.menuItem.tag.should.equal m.tag
    m.menuItem.image.should.equal m.image
    m.menuItem.state.should.equal m.state
  end

  it "exposes an RACCommand instance for subscribing" do
    m = DrinkMenu::MenuItem.itemWithLabel :create_site, title: 'Create Site'
    m.should.respond_to :subscribe
    m.command.should.respond_to :execute
    m.command.should.respond_to :subscribeNext
  end

  it "delegates subscribing to RACCommand" do
    m = DrinkMenu::MenuItem.itemWithLabel :create_site, title: 'Create Site'
    called = false
    m.subscribe do |value|
      value.should.equal [:create_site, m]
      called = true
    end
    m.rac_command.execute(m.menuItem)
    called.should.be.true
  end

  it "allows setting a canExecuteSignal on the RACCommand instance" do
    m = DrinkMenu::MenuItem.itemWithLabel :create_site, title: 'Create Site'
    signal = RACSubject.subject
    m.canExecuteSignal = signal
    m.subscribe do
    end
    signal.sendNext true
    m.isEnabled.should.be.true
    signal.sendNext false
    m.isEnabled.should.be.false
  end

  it "allows creating separator items" do
    item = DrinkMenu::MenuItem.separatorItem
    item.isSeparatorItem.should.be.true
  end

  def separator_id(item)
    item.label[/\d+$/].to_i
  end

  it "generates unique label for separators" do
    item1 = DrinkMenu::MenuItem.separatorItem
    item2 = DrinkMenu::MenuItem.separatorItem
    separator_id(item2).should.equal separator_id(item1) + 1
  end

end
