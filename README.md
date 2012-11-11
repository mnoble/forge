# Forge

A Factory library that's about as barebones as you can get.

## Installation

    # "forge" was taken -_-

    gem "forge-factories"
    $ bundle install

    # or

    gem install forge-factories

## Define Factories

```ruby
Forge.define(:user, User) do |u|
  u.name = "Spike Spiegel"
  u.location = "Mars"
end
```

## Defining Factories That Use Other Factories

```ruby
Forge.define(:ship, Ship) do |s|
  s.name = "Bebop"
end

Forge.define(:user, User) do |u|
  u.name = "Spike Spiegel"
  u.ship = Forge.build(:ship)
end
```

## Building Objects

```ruby
Forge.build(:user)
```

## Building Objects and Overriding Attributes

```ruby
Forge.build(:user, name: "Jet")
```

## DSL

You can drop the `Forge` part of the methods if you include
`Forge::DSL`.

```ruby
RSpec.configure do |config|
  config.include Forge::DSL
end

it "..." do
  build(:user).should be_awesome
end
```

## Errors

`Forge::DuplicateFactoryError`
Raised when you try to define two factories using the same name.

`Forge::MissingFactoryError`
Raised when you try to build a factory that has not been defined.
