module Metaconfig
  module Loaders
    class BaseLoader
      def read
        raise NotImplementedError
      end

      def has_key?(key)
        raise NotImplementedError
      end
    end
  end
end