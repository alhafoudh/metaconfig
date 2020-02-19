require 'metaconfig/version'

module Metaconfig
  class Settings
    attr_reader :_name
    attr_reader :_settings
    attr_reader :_sections

    def initialize(name, settings, sections)
      @_name = name
      @_settings = settings
      @_sections = sections
    end

    def to_h
      hash = {}

      _settings.reduce(hash) do |acc, setting|
        value = instance_variable_get(:"@#{setting}")
        acc[setting] = value
        acc
      end

      _sections.reduce(hash) do |acc, subsection|
        value = instance_variable_get(:"@#{subsection}")
        acc[subsection] = value.to_h
        acc
      end

      hash
    end
  end

  class << self
    attr_reader :definition

    def define(&block)
      undefine
      @definition = Definition::Section.new(&block)
      reload
      definition
    end

    attr_reader :configuration

    def reload
      @configuration = build(definition, self)
    end

    def undefine
      @definition = nil
      @configuration = nil
      remove_const(:RootSettings) if const_defined?(:RootSettings)
    end

    def method_missing(*args)
      configuration.public_send(*args)
    end

    private

    def build(section, parent)
      klass = build_settings_class(section, parent)
      instance = instantiate_settings(section, klass)
      populate_settings_values(section, instance, klass)

      instance
    end

    def build_settings_class(section, parent)
      klass = Class.new(Settings)
      parent.const_set("#{section.name.capitalize}Settings", klass)

      # define setting readers
      section.settings.map do |setting|
        klass.attr_reader(setting.name.to_sym)
      end

      # define subsection readers
      section.sections.map do |subsection|
        klass.attr_reader(subsection.name.to_sym)
      end

      klass
    end

    def instantiate_settings(section, klass)
      klass.new(
          section.name.to_sym,
          section.settings.map(&:name).map(&:to_sym),
          section.sections.map(&:name).map(&:to_sym),
      )
    end

    def populate_settings_values(section, instance, klass)
      # setting values
      section.settings.map do |setting|
        instance.instance_variable_set(:"@#{setting.name}", :"#{setting.name} value")
      end

      # section values
      section.sections.map do |subsection|
        section_instance = build(subsection, klass)
        instance.instance_variable_set(:"@#{subsection.name}", section_instance)
      end
    end
  end
end
