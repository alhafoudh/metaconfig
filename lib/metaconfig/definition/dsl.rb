module Metaconfig
  module Definition
    class DSL
      attr_reader :definition

      def initialize(definition, &block)
        @definition = definition
        instance_eval(&block) if block_given?
      end

      def setting(*args, **opts)
        definition.settings << Setting.new(*args, **opts)
      end

      def section(*args, **opts, &block)
        new_section = Section.new(*args, **opts)
        definition.sections << new_section
        DSL.new(new_section, &block)
      end
    end
  end
end