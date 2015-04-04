# Instamojo API for Ruby

`instamojo-gem` is an un-official ruby client for [Instamojo API](https://www.instamojo.com/developers/rest/). Instamojo API lets you manage payment links directly in into your application. It currently supports version `1.1`.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'instamojo'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install instamojo


## Authentication Keys

You can find your API_KEY and AUTH_TOKEN at the API Documentation Page. Create an account on Instamojo, log in and visit this [link](https://www.instamojo.com/api/1.1/docs/)

## Usage

Before making any calls, you must supply api_key and auth_token to instamojo-gem. By default it will take `ENV['IMOJO_API_KEY']` as api_key and `ENV['IMOJO_AUTH_TOKEN]` as auth_token. You can also configure these credentials like

```
Instamojo.api_key = 'xxxx'
Instamojo.auth_token = 'xxx'

# OR

Instamojo::Client.new(api_key: 'xxx', auth_token: 'xxx')

```

instamojo-gem provides following functions to interact with the API:

* `links`
* `link_edit(slug, options = {})`
* `link_details(slug)`
* `link_create(title, description, base_price, options = {})`
* `link_delete(slug)`
* `payments`
* `payment_details(payment_id)`


You can either access above methods with `Instamojo` module or instantiating new client with api credentials like:

```
## To get a link's detail
Instamojo.link_details('test-123')

## Or
client = Instamojo::Client.new(api_key: 'xxx', auth_token: 'xxx')
client.link_details('test-123')

```

Please open an issue to report bugs or enhancements.


## Contributing

1. Fork it ( https://github.com/[my-github-username]/instamojo/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
