# SpaceX Closest Satellites :rocket:
![](http://i.kinja-img.com/gawker-media/image/upload/s--CuKZAzxf--/loqnlt3ori4ejg1eytsy.gif)
### This app will list "N" satellites close to a given point (latitude, longitude).
## Getting Started
### Assuming you have Ruby 3.1.2 and Rails 7.0.4
```bash
bundle install
rails db:create db:migrate # TODO: Remove database from project since its not using yet
```
### Running locally

We use foreman to make it easier to run the various apps locally and have some scripts to help.

```bash
bin/dev # runs everything

# run individual services
bin/dev web # runs rails
bin/dev js # runs js
bin/dev css # runs css
```

## API Docs

Example:
GET `/satellites?number_of_satellites=2&latitude=40.71427&longitude=-74.00597` To show closest satellites.

## Debugging

Ruby 3.0+ added a new built in debugger called [debug](https://github.com/ruby/debug). Rails 7 uses this by default.

I'm also including a more standard [byebug](https://github.com/deivid-rodriguez/byebug) debugger via [pry-byebug](https://github.com/deivid-rodriguez/pry-byebug).

You can use different breakpoints methods to use one or the other.

```
binding.break # use ruby's built in debugger
binding.pry   # use byebug debugger
```

Note that Rails and Byebug both define a `debugger` alias. But `byebug`'s debugger is picked when you use that alias. It's better to be explicit about which debugger you want.

### Setting breakpoints
Insert a `debugger` statement in any Ruby code to stop execution at that point and launch a REPL. See [Debugging with the debug gem](https://guides.rubyonrails.org/debugging_rails_applications.html#debugging-with-the-debug-gem).


### Specs

##### Running tests
Setup
```
bin/rails db:test:prepare
```

Running
```sh
bin/rspec
bin/rspec spec/path/to/myfile.rb
bin/rspec spec/path/to/myfile.rb:50
```
