require 'metaconfig/version'
require 'metaconfig/definition'
require 'metaconfig/values'

require 'metaconfig/configure'
require 'metaconfig/define'

module Metaconfig
  include Configure
  include Define
end
