module Metaconfig
  module Loaders
    class EnvLoader < BaseLoader
      attr_reader :env

      def initialize(env)
        @env = env
      end

      def read(key)
        raise(Errors::MissingKeyValueError, receiver: self, key: env_name(key)) unless has_key?(key)

        env.fetch(env_name(key))
      end

      def has_key?(key)
        env.has_key?(env_name(key))
      end

      private

      def env_name(key)
        key.map(&:upcase).join('_')
      end
    end
  end
end