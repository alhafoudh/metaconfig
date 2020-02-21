module Metaconfig
  module Definition
    class Section
      attr_reader :name
      attr_reader :settings
      attr_reader :sections
      attr_reader :options

      attr_accessor :loader

      def initialize(name = :root, settings: [], sections: [], loader: nil, **options, &block)
        @name = name
        @settings = settings
        @sections = sections
        @loader = loader
        @options = options
        instance_eval(&block) if block_given?
      end

      def setting(*args, **opts)
        @settings << Setting.new(*args, **opts)
      end

      def section(*args, **opts, &block)
        @sections << Section.new(*args, **opts, &block)
      end

      def assign_default_loaders
        settings.map do |setting|
          setting.loader = loader if setting.loader.nil?
        end

        sections.map do |subsection|
          subsection.loader = loader if subsection.loader.nil?
        end
      end
    end
  end
end