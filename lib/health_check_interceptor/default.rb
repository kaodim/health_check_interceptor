require 'ostruct'
require 'json'
require 'active_support/core_ext/class'

module HealthCheckInterceptor
  class Default
    class_attribute :configuration,
                    instance_write: false,
                    default: OpenStruct.new(
                      url_pattern: %r{(\/|\/are_you_alive)$},
                      response_code: 200,
                      headers: {},
                      body: [{ message: 'I am alive.' }.to_json]
                    )
    alias config configuration

    def self.configure(&block)
      block.yield(configuration)
    end

    def initialize(app)
      @app = app
    end

    def call(env)
      if env['REQUEST_URI'] =~ config.url_pattern
        [config.response_code, config.headers, config.body]
      else
        @app.call(env)
      end
    end
  end
end
