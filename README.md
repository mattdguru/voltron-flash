[![Coverage Status](https://coveralls.io/repos/github/ehainer/voltron-flash/badge.svg?branch=master)](https://coveralls.io/github/ehainer/voltron-flash?branch=master)
[![Build Status](https://travis-ci.org/ehainer/voltron-flash.svg?branch=master)](https://travis-ci.org/ehainer/voltron-flash)
[![License: GPL v3](https://img.shields.io/badge/License-GPL%20v3-blue.svg)](http://www.gnu.org/licenses/gpl-3.0)

# Voltron::Flash

Unifying `flash` and `flash.now` logic into one single method, while also being able to pass flash messages easily through AJAX requests.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'voltron-flash', '~> 0.1.6'
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install voltron-flash

Then run the following to create the voltron.rb initializer (if not exists already) and add the upload config:

    $ rails g voltron:flash:install

Also, include the necessary js and css by adding the following to your application.js and application.css respectively

```javascript
//= require voltron-flash
```

```css
/*
 *= require voltron-flash
 */
```

If you want to customize the out-of-the-box functionality or styles, you can copy the assets (javascript/css) to your app assets directory by running:

    $ rails g voltron:flash:install:assets
    
Optionlly, you may copy the flash markup template by running:

    $ rails g voltron:flash:install:views

The template will be placed in the `<rails_root>/app/views/voltron/flash/` directory.

## Usage

Voltron Flash is designed to handle flash messages appropriately depending on whether a controller renders or redirects, and whether or not the request is an AJAX request. All the developer needs to do is use the new `flash!` message.

```ruby
class UserController < ActionController::Base

  def create
    @user = User.new(user_params)
    
    if @user.save
      flash! notice: 'User created successfully'
      redirect_to user_path(@user)

      # Or, you can still add flashes like so if you want. The old ways still work fine
      redirect_to user_path(@user), notice: 'User created successfully'
    else
      flash! alert: @user.errors.full_messages
      render :new
    end
    
    # ... define other things, like our +user_params+ method
  end

end
```

I hear you: "What's the point of that? You just made a single method that determines whether to use flash vs. flash.now. That's pretty boring."

Meh, depends on your perspective. But part of what makes this useful is it's ability to pass flash messages back as a part of the AJAX response headers.

Using that same example controller from above, the following code (assuming jQuery) is all that's required to handle the flash messages given an AJAX request to the same `create` action.

```js
$.ajax({
  url: '/users/create',
  method: 'POST',
  data: {
    authenticity_token: '...'
    first_name: 'Test',
    last_name: 'Example',
    email: '',
    // ...
  }
})
```

Note that there is nothing in that code that relates specifically to the handling flash messages. That's because that is entirely handled by the Voltron Flash js module (see: Installation, specifically for assets).

## Module Usage

Included with the gem is a Voltron module that handles the creation/addition/removal of flash messages. Out of the box there should be little to nothing you need to do with it, as it's fairly flexible in terms of how it can be used already.

The most commonly utilized methods will likely be `new` and `clear`, which are used like so:

```js
// Adds several messages at once with optionally defined options
Voltron('Flash/new', {
  notice: 'This is a notice message', // Specify as single message,
  alert: ['This is an alert', 'This too is an alert'] // or an array of messages
}, {
  bind: '#container',
  group: true
});

// To clear all flash messages
Voltron('Flash/clear');
// To clear a specific flash message by fading it out over 1 second
Voltron('Flash/clear', {
  element: '.selector-matching-flash-or-child-element' // Can be css selector, raw DOM element, or jQuery object
}, {
  concealMethod: 'fadeOut',
  concealTime: 1000
});

// The above is functionally equivalent to:

Voltron.getModule('Flash').new({
  notice: 'This is a notice message',
  alert: ['This is an alert', 'This too is an alert']
}, {
  bind: '#container',
  group: true
});

// To clear all flash messages
Voltron.getModule('Flash').clear();
// To clear a specific flash message by fading it out over 1 second
Voltron.getModule('Flash').clear({
  element: '.selector-matching-flash-or-child-element' // Can be css selector, raw DOM element, or jQuery object
}, {
  concealMethod: 'fadeOut',
  concealTime: 1000
});
```

## Configuration

#### Rails Configuration

| Option | Default | Comment                                                                                                                                                                                                                                                                                                                           |
|--------|---------|-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| header | X-Flash | The AJAX response header that will contain the flash messages JSON. Should be no reason to change this unless it conflicts with an already defined response header.                                                                                                                                                               |
| group  | true    | Whether or not to "group" flash messages of the same type together in a single container with one "close" button. If `false`, each flash message regardless of type will be in it's own containing div with it's own close (X) button. This option can be overridden when adding flash messages via the js module's `new` method. |

#### Module Configuration

The following are options that can optionally be defined as the second argument to the module's `new` or `clear` methods. Each can also be set as a "default" by calling `Voltron('Flash/setConfig', { option: value, ... })` in a module initializer. Useful for reducing the amount of code needed to be written, since you can define things like `bind` once instead of every time you add a flash message.

| Option         | Default   | Comment                                                                                                                                                                                                                                                                                |
|----------------|-----------|----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| class          | (blank)   | A css class (or class names) to be added to the newly created flash message div. Note that this is different than the `containerClass` option, which adds a class to the wrapping div.                                                                                                 |
| bind           | body      | A css selector, jQuery object, or raw DOM element that will be the target for added flash messages. You can control where the markup is injected relative to this element with the `addMethod` option.                                                                                 |
| id             | flashes   | A unique id of the containing flash div (the wrapper element). If this is changed and flash messages can possibly be shown upon page render, it's important that you change the id of the element in the flash template as well (see: Installation, specifically the part about views) |
| containerClass | (blank)   | A css class (or class names) to be added to the wrapper div when a flash message is added. If the wrapper div is already present on the page when a new flash message is added, this class will be added then.                                                                         |
| addMethod      | prepend   | One of [prepend](http://api.jquery.com/prepend/), [append](http://api.jquery.com/append/), [before](http://api.jquery.com/before/), or [after](http://api.jquery.com/after/), determines where the wrapper div will appear relative to the `bind` element.                             |
| revealMethod   | slideDown | Any jQuery method that could be used to reveal the flash element. Go-to options are among slideDown/slideUp, fadeIn, or show                                                                                                                                                           |
| revealTime     | 200       | The time (is milliseconds) to reveal the element using `revealMethod`. Will always be passed as the first argument to `revealMethod`, regardless of what it is.                                                                                                                        |
| concealMethod  | slideUp   | Any jQuery method that could be used to hide the flash element when closed. Go-to options are among slideDown/slideUp, fadeOut, or hide                                                                                                                                                |
| concealTime    | 200       | The time (is milliseconds) to hide the element using `concealMethod`. Will always be passed as the first argument to `concealMethod`, regardless of what it is.                                                                                                                        |
| autoClose      | false     | If true, will automatically hide the flash message after `autoCloseAfter` milliseconds                                                                                                                                                                                                 |
| autoCloseAfter | 5000      | The number of milliseconds to allow the flash message to be visible after it's added.                                                                                                                                                                                                  |
| autoAdd        | true      | This controls whether or not to automatically insert flash messages picked up by responding AJAX requests using the options defined. If false, it's assumed that one will observe the `onFlashReceived` event and handle things on their own.                                          |

## Events

Keeping it simple, the Flash module only dispatches one event out of the box. More can be added as needed by modifying `voltron-flash.js`, but for now:

| Event Name     | Callback Function | Data                                                                                                                                                                                                                                                                                                                                      | Comment                                                                                |
|----------------|-------------------|-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|----------------------------------------------------------------------------------------|
| flash:received | onFlashReceived   | <ul><li>**flash:** The Voltron Flash JS instance</li><li>**flashes:** An object of received flash messages. The key is the flash message type (notice, alert, etc.), the value is always an array of messages.</li><li>**request:** The XHR object of the AJAX request</li><li>**event:** The AJAX completion event from jQuery</li></ul> | Dispatched as soon as an [AJAX request completes](http://api.jquery.com/ajaxComplete/) |

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/ehainer/voltron-flash. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [GNU General Public License](https://www.gnu.org/licenses/gpl-3.0.en.html).

