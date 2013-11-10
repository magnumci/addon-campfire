# Campfire Addon

Send [Magnum CI](http://magnum-ci.com) build notifications to a Campfire room

## Usage

Example:

```ruby
require "magnum/addons/campfire"

# Initialize addon
addon = Magnum::Addons::Campfire.new(
  api_token: "token", 
  subdomain: "team", 
  room: "room id"
)

# Send build payload
addon.run(build_payload)
```

## Configuration

Available options:

- `api_token` - Campfire api token
- `subdomain` - Campfire subdomain (https://[team].campfirenow.com)
- `room`      - Room ID

## Testing

Execute test suite:

```
bundle exec rake test
```

## License

Copyright (c) 2013 Dan Sosedoff, Magnum CI

MIT License