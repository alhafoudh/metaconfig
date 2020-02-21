module Metaconfig
  module Values
    class Settings
      module Builder
        def self.included(base)
          base.send :include, InstanceMethods
          base.extend ClassMethods
        end

        module InstanceMethods
          def instantiate_sections
            klass = self.class
            klass.definition.sections.map do |section|
              section_instance = klass.build_from(section, self.class)
              _set_value(section.name, section_instance)
            end
          end
        end

        module ClassMethods
          attr_reader :definition

          def build_from(definition, parent_class)
            klass = Class.new(self)
            klass.build(definition)
            parent_class.const_set("#{definition.name.capitalize}Settings", klass)

            klass.new
          end

          protected

          def build(definition)
            @definition = definition
            build_settings
            build_sections
          end

          def build_settings
            definition.settings.map do |setting|
              attr_reader(setting.name.to_sym)
            end
          end

          def build_sections
            definition.sections.map do |section|
              attr_reader(section.name.to_sym)
            end
          end
        end
      end
    end
  end
end