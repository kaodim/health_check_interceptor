require 'active_support/core_ext/class'
require 'active_support/core_ext/module'

module HealthCheckInterceptor
  class Default
    class_attribute :configurable,
                    instance_write: false

    self.configurable = HealthCheckInterceptor::Configuration.configs

    class << self
      delegate :configure, :configuration, to: :configurable
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

    def config
      self.class.configurable.configuration
    end
  end
end
