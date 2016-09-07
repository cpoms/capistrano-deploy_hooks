# Capistrano::DeployHooks

This is a small framework for generating webhooks for the various stages of a Capistrano deploy. It comes with some messengers prepacked, for example Mattermost.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'capistrano-deploy_hooks'
```

And then execute:

    $ bundle

## Usage

In your Capfile:

```ruby
require 'capistrano/deploy_hooks'
```

In your Capistrano config:

```ruby
# or another messenger from somewhere
require 'capistrano/deploy_hooks/messengers/mattermost'

if ENV['WEBHOOK_URI']
  set :deploy_hooks, {
    messenger: Capistrano::DeployHooks::Messengers::Mattermost,
    webhook_uri: ENV['WEBHOOK_URI'],
  }
end
```

## Messengers

Messengers should respond to `payload_for(action)`, and return Hash 'payloads', with the following optional actions: updating, reverting, updated, reverted, failed. They should also respond to `webhook_for(action)` and return a URI to post the webhook to. See `capistrano/deploy_hooks/messengers/mattermost.rb` as an example of this. Messengers are initialized with the hash config passed to capistrano's `set :deploy_hooks` call.

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/capistrano-mattermost.

