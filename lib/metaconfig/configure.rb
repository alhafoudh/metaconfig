require 'metaconfig/configuration'

module Metaconfig
  module Configure
    def self.included(base)
      base.send :include, InstanceMethods
      base.extend ClassMethods
    end

    module InstanceMethods
    end

    module ClassMethods
      attr_reader :config

      def configure(&block)
        @config = Configuration::Config.new
        Configuration::DSL.new(config, &block)
        config
      end
    end
  end
end
