module Metaconfig
  module Loaders
    module Errors
      class MissingKeyValueError < KeyError
        def initialize(receiver:, key:)
          super('key not found: %s' % key.inspect, receiver: receiver, key: key)
        end
      end
    end
  end
end