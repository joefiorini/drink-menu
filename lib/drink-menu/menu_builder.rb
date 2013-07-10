module DrinkMenu
  module MenuBuilder

    class Context
        def initialize(menu, menuItems={})
          @menu = menu
          @menuItems = menuItems
        end

        def ___
          @menu << MenuItem.separatorItem
        end

        def method_missing(meth, *args)
          if @menuItems.key?(meth)
            @menu << @menuItems[meth]
          else
            super
          end
        end
    end

    def <<(item)
      @menuItems ||= {}
      @menuItems[item.label] = item
    end

    def menuItem(label, title: title)
      @menuItems ||= {}
      @menuItems[label] = MenuItem.itemWithLabel label, title: title
    end

    def menuItem(label, title: title, submenu: submenu)
      @menuItems ||= {}
      @menuItems[label] = MenuItem.itemWithLabel label, title: title, submenu: @menus[submenu]
    end

    def menuItem(label, &block)
      @menuItems ||= {}
      @menuItems[label] = MenuItem.itemWithLabel label, &block
    end

    def statusBarMenu(label, title: title, &block)
      @menus ||= {}
      @menus[label] = Menu.statusMenuWithLabel label, title: title, &block
    end

    def statusBarMenu(label, icon: image, statusItemViewClass: statusItemViewClass, &block)
      @menus ||= {}
      @menus[label] = Menu.statusMenuWithLabel label, icon: image, statusItemViewClass: statusItemViewClass, &block
    end

    def statusBarMenu(label, icon: image, &block)
      @menus ||= {}
      @menus[label] = Menu.statusMenuWithLabel label, icon: image, &block
    end

    def menu(label, title: title, &block)
      @menus ||= {}
      @menus[label] = Menu.menuWithLabel label, title: title, &block
    end

    def menu(label, itemsFromCollection: collection, titleProperty: property)
      @menus ||= {}
      @menus[label] = Menu.menuWithLabel label, itemsFromCollection: collection, titleProperty: property
    end

    def [](label)
      @menus[label]
    end

    def build!
      @menus.values.each do |menu|
        context = Context.new(menu, @menuItems.dup)
        context.instance_eval(&menu.builder) if menu.builder
        if menu.needsStatusItem?
          menu.createStatusItem!
        end
      end
    end

  end
end
