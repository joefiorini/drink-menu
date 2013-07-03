module DrinkMenu
  class MenuItem
    extend Forwardable

    attr_accessor :label, :menuItem, :command, :canExecuteSignal

    def_delegators :@menuItem, :isEnabled, :setEnabled, :enabled=,
                    :tag, :setTag, :tag=,
                    :image, :setImage, :image=,
                    :state, :setState, :state=,
                    :title, :setTitle, :title=,
                    :isHidden, :setHidden, :hidden=,
                    :isHiddenOrHasHiddenAncestor,
                    :target, :setTarget, :target=,
                    :action, :setAction, :action=,
                    :onStateImage, :setOnStateImage, :onStateImage=,
                    :offStateImage, :setOffStateImage, :offStateImage=,
                    :mixedStateImage, :setMixedStateImage, :mixedStateImage=,
                    :submenu, :setSubmenu, :submenu=,
                    :hasSubmenu,
                    :parentItem,
                    :isSeparatorItem,
                    :menu, :setMenu, :menu=,
                    :keyEquivalent, :setKeyEquivalent, :keyEquivalent=,
                    :keyEquivalentModifierMask, :setKeyEquivalentModifierMask, :keyEquivalentModifierMask=,
                    :isAlternate, :setAlternate, :alternate=,
                    :indentationLevel, :setIndentationLevel, :indentationLevel=,
                    :toolTip, :setToolTip, :toolTip=,
                    :representedObject, :setRepresentedObject, :representedObject=,
                    :view, :setView, :view=,
                    :rac_command, :rac_command=,
                    :rac_stateSignal, :rac_stateSignal=,
                    :isHighlighted

    def self.itemWithLabel(label, title: title)
      new.tap do |item|
        item.label = label
        item.title = title
      end
    end

    def self.itemWithLabel(label, title: title, submenu: submenu)
      new.tap do |item|
        item.label = label
        item.title = title
        item.submenu = submenu.menu
      end
    end

    def self.itemWithLabel(label, &block)
      new.tap do |item|
        item.label = label
        block.call item
      end
    end

    def self.separatorItem
      @@separatorId ||= 0
      @@separatorId += 1
      label = :"separator#{@@separatorId}"
      new(NSMenuItem.separatorItem).tap do |item|
        item.label = label
      end
    end

    def initialize(menuItem=nil)
      @menuItem = menuItem || NSMenuItem.alloc.init
    end

    def command=(command)
      self.rac_command = command
    end

    def command
      self.rac_command ||= if canExecuteSignal
                             RACCommand.commandWithCanExecuteSignal canExecuteSignal
                           else
                             RACCommand.command
                           end

      self.rac_command
    end

    def subscribe(&block)
      command.map(->(value){
        [label, self]
      }).subscribeNext(block)
    end

  end

end
