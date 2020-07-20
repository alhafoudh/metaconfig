module Metaconfig
  module Errors
    class MissingSettingValueError < KeyError
      def initialize(receiver:, key:)
        super('Missing setting value for key: ' % key.inspect, receiver: receiver, key: key)
      end
    end
  end
end