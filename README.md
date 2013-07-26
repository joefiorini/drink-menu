# DrinkMenu

## Installation

Add this line to your application's Gemfile:

    gem 'drink-menu'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install drink-menu

## Usage

Drink Menu separates menu layout from menu definition. Menu definition looks like:


```ruby
class MainMenu
  extend DrinkMenu::MenuBuilder

  menuItem :progress do |item|
  end

  menu :sites_list, itemsFromCollection: Staticly.sitesList, titleProperty: :name

  menuItem :open_site, title: 'Open Site', submenu: :sites_list

  menuItem :create_site, title: 'Create Site'
  menuItem :export, title: 'Export to Folder...'
  menuItem :import, title: 'Import Folder as Site...'
  menuItem :force_rebuild, title: 'Force Rebuild'
  menuItem :about, title: 'About Staticly'
  menuItem :quit, title: 'Quit'


  iconImage = NSImage.imageNamed "status-icon-off"
  iconImage.template = true

end
```

and then layout is as simple as:

```ruby

class MainMenu
  extend DrinkMenu::MenuBuilder

  statusBarMenu :main_menu, icon: iconImage, statusItemViewClass: StatusItemView do
    open_site
    create_site
    ___
    export
    import
    force_rebuild
    ___
    about
    quit
  end

end
```

See the [example](https://github.com/joefiorini/drink-menu/tree/master/examples/basic_main_menu) for basic usage. More detailed documentation & examples coming soon.

[See my recent blog post](http://joefiorini.com/posts/generating-menus-in-osx-apps-the-ruby-way) for a bit more information.

## Running the Examples

To run our example apps:

1. Clone this repo
2. From within your clone's root, run `platform=osx example=basic_main_menu rake`

You can replace the value of `example` with any folder under the `examples` directory to run that example.

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
