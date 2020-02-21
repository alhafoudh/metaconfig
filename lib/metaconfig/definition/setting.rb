module Metaconfig
  module Definition
    class Setting
      attr_reader :name
      attr_reader :type
      attr_reader :options

      def initialize(name, type = :string, **options)
        @name = name
        @type = type
        @options = options
      end

      def required
        options.fetch(:required, false)
      end
    end
  end
end