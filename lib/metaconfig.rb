require 'metaconfig/version'
require 'metaconfig/errors'
require 'metaconfig/definition'
require 'metaconfig/values'
require 'metaconfig/loaders'

require 'metaconfig/configure'
require 'metaconfig/define'

module Metaconfig
  include Configure
  include Define
end
