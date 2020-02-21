require 'metaconfig/values/settings/builder'

module Metaconfig
  module Values
    class Settings
      include Builder

      def initialize
        instantiate_sections
      end

      def to_h
        hash = {}
        definition = self.class.definition

        definition.settings.reduce(hash) do |acc, setting|
          name = setting.name
          value = _get_value(name)
          acc[name] = value
          acc
        end

        definition.sections.reduce(hash) do |acc, subsection|
          name = subsection.name
          value = _get_value(name)
          acc[name] = value.to_h
          acc
        end

        hash
      end

      def load_values
        load_settings_values
        load_section_values
      end

      private

      def load_settings_values
        self.class.definition.settings.map do |setting|
          name = setting.name
          _set_value(name, :"#{name} value")
        end
      end

      def load_section_values
        self.class.definition.sections.map do |section|
          _get_value(section.name).load_values
        end
      end

      def _get_value(attribute_name)
        instance_variable_get(:"@#{attribute_name}")
      end

      def _set_value(attribute_name, value)
        instance_variable_set(:"@#{attribute_name}", value)
      end
    end
  end
end
