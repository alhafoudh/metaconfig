module Metaconfig
  module Definition
    class Setting
      attr_reader :name
      attr_reader :type
      attr_accessor :loader
      attr_reader :options

      def initialize(name, type = :string, loader: nil, **options)
        @name = name
        @type = type
        @loader = loader
        @options = options
      end

      def required
        options.fetch(:required, false)
      end
    end
  end
end