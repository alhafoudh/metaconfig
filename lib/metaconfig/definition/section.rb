module Metaconfig
  module Definition
    class Section
      attr_reader :name
      attr_reader :settings
      attr_reader :sections
      attr_reader :options

      def initialize(name = :root, settings: [], sections: [], **options, &block)
        @name = name
        @settings = settings
        @sections = sections
        @options = options
        instance_eval(&block) if block_given?
      end

      def setting(*args, **opts)
        @settings << Setting.new(*args, **opts)
      end

      def section(*args, **opts, &block)
        @sections << Section.new(*args, **opts, &block)
      end
    end
  end
end