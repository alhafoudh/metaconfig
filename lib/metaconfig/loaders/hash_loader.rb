module Metaconfig
  module Loaders
    class HashLoader < BaseLoader
      attr_reader :hash

      def initialize(hash)
        @hash = hash
      end

      def read(key)
        raise Errors::MissingKeyValueError.new(receiver: self, key: key) unless has_key?(key)

        hash.dig(*key)
      end

      def has_key?(key)
        key_without_last = key[0..-2]
        last_base_value = key_without_last.empty? ? hash : hash.dig(*key_without_last)
        return true if last_base_value.is_a?(Hash) && last_base_value.has_key?(key.last)
        false
      end
    end
  end
end