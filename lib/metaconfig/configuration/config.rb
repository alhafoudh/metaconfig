module Metaconfig
  module Configuration
    class Config
      attr_accessor :default_loader
      attr_accessor :loaders

      def initialize(default_loader = nil, loaders = {})
        @default_loader = default_loader
        @loaders = loaders
      end
    end
  end
end