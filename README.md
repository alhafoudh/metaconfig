# metaconfig

Library to handle runtime configuration in local and cloud environments.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'metaconfig'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install metaconfig

## Usage

```ruby
# ENV contents:
#
# SECRET_KEY_BASE=123
# POSTMARK_API_TOKEN=123
# MAIL_FROM=john@example.com
# MAIL_OVERRIDE_TO=dave@example.com

Metaconfig.configure do
  default_loader Metaconfig::Loaders::EnvLoader.new
end

Metaconfig.define do
  setting :secret_key_base, :string, required: true
  setting :postmark_api_token, :string
  section :mail do
    setting :from, :email, required: true
    setting :override_to, :email
  end
end

puts Metaconfig.secret_key_base
puts Metaconfig.mail.from
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/alhafoudh/metaconfig.
