module Metaconfig
  module Define
    def self.included(base)
      base.send :include, InstanceMethods
      base.extend ClassMethods
    end

    module InstanceMethods
    end

    module ClassMethods
      attr_reader :definition
      attr_reader :root

      def define(&block)
        undefine
        @definition = Definition::Section.new
        Definition::DSL.new(definition, &block)

        reload
        definition
      end

      def reload
        @root = build(definition, self)

        root.load_values
      end

      def undefine
        @definition = nil
        @root = nil
        remove_const(:RootSettings) if const_defined?(:RootSettings)
      end

      def method_missing(*args)
        root.public_send(*args)
      end

      private

      def build(definition, parent_class)
        Values::Settings.build_from(definition, parent_class)
      end
    end
  end
end
