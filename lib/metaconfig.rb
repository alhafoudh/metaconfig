require 'metaconfig/version'
require 'metaconfig/definition'
require 'metaconfig/values'

module Metaconfig
  class << self
    attr_reader :definition

    def define(&block)
      undefine
      @definition = Definition::Section.new(&block)
      reload
      definition
    end

    attr_reader :root

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

    def build(definition, parent)
      Values::Settings.build_from(definition, parent)
    end
  end
end
