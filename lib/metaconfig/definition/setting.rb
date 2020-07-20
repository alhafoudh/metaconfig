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

      def key
        name # TODO: build key
      end

      def required
        options.fetch(:required, false)
      end

      def active_loader
        loader || Metaconfig.config.default_loader
      end

      def value
        return if active_loader.nil? || !active_loader.respond_to?(:read)

        active_loader.read(key)
      end
    end
  end
end