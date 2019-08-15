require 'ostruct'
require 'json'
require 'singleton'

module HealthCheckInterceptor
  class Configuration
    include Singleton

    attr_reader :configuration

    def self.configure(&block)
      configs.configure(&block)
    end

    def self.configs
      instance
    end

    def initialize
      @configuration = OpenStruct.new(
        url_pattern: %r{(\/|\/are_you_alive)$},
        response_code: 200,
        headers: {},
        body: [{ message: 'I am alive.' }.to_json]
      )
    end

    def configure(&block)
      block.call(configuration)
    end
  end
end