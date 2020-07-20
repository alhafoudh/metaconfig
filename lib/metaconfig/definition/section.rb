module Metaconfig
  module Definition
    class Section
      attr_accessor :parents
      attr_reader :name
      attr_reader :settings
      attr_reader :sections
      attr_reader :options

      attr_accessor :loader

      def initialize(name = :root, settings: [], sections: [], loader: nil, **options)
        @parents = []
        @name = name
        @settings = settings
        @sections = sections
        @loader = loader
        @options = options
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