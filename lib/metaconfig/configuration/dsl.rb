module Metaconfig
  module Configuration
    class DSL
      attr_reader :config

      def initialize(config, &block)
        @config = config
        instance_eval(&block) if block_given?
      end

      def default_loader(loader)
        config.default_loader = loader
      end

      def loader(name, loader)
        config.loaders[name] = loader
      end
    end
  end
end