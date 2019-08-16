# HealthCheckInterceptor

Welcome to your new gem! In this directory, you'll find the files you need to be able to package up your Ruby library into a gem. Put your Ruby code in the file `lib/health_check_interceptor`. To experiment with that code, run `bin/console` for an interactive prompt.

The health check interceptor is to handle the frequent heatlh check ping request from health checker and prevent it going any further in the middleware stack. Health check is supposed to be simple and should not require any complex handling or database connection.

By intercepting the request earlier in the upperstream middleware stack, this will reduce application server load/resource consumption, especially when there is database or cache query in the downstream middelware stack.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'health_check_interceptor', github: 'https://github.com/kaodim/health_check_interceptor'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install health_check_interceptor

## Usage

The gem has a `Default` interceptor with pre-defined configuration **health check url pattern matcher**, **response code** and **response body**. To override this, you may use the `configure` interface to do that.

```ruby
# app/config/initializer/health_check_interceptor.rb
HealthCheckInterceptor::Default.configure do |config|
  config.url_pattern = /your_healt_check_url_pattern/
  config.response_code = 201
  config.body = ["Still hanging there..."]
end
```

To extend the behaviour of the interceptor, you may subclass from `HealthCheckInterceptor::Default`. Also you need to implement a different singleton `Configuration` (under appropriate namespacing) class for your custom intercetor. The `Configuration` implementation is a must if you want to subclass a custom interceptor!

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`.

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/kaodim/health_check_interceptor.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
