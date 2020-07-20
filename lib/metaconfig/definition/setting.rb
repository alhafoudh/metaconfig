module Metaconfig
  module Definition
    class Setting
      attr_accessor :parents
      attr_reader :name
      attr_reader :type
      attr_accessor :loader
      attr_reader :options

      def initialize(name, type = :string, loader: nil, **options)
        @parents = []
        @name = name
        @type = type
        @loader = loader
        @options = options
      end

      def key_path
        @key_path ||= (parents.map(&:name) + [name])
      end

      def required
        val = options.fetch(:required, false)
        return val if [true, false].include?(val)
        false
      end

      def active_loader
        loader || Metaconfig.config.default_loader
      end

      def value
        return if active_loader.nil? || !active_loader.respond_to?(:read)

        active_loader.read(key_path)
      rescue Loaders::Errors::MissingKeyValueError => ex
        raise ex if required # TODO: this must be different custom error
        nil # TODO: default value should be used if any
      end
    end
  end
end