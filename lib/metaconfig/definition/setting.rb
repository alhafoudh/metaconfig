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

      def default_value
        options.fetch(:default, nil)
      end

      def active_loader
        loader || Metaconfig.config.default_loader
      end

      def value
        return default_value if active_loader.nil?

        active_loader.read(key_path)
      rescue Loaders::Errors::MissingKeyValueError => ex
        raise(Errors::MissingSettingValueError, receiver: self, key: ex.key) if required
        default_value
      end
    end
  end
end