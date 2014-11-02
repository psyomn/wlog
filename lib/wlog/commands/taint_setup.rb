require 'fileutils'
require 'wlog/commands/commandable'
require 'wlog/domain/static_configurations'

module Wlog
# This touches a file in wlog config: .config/wlog/tainted. That file is used
# later on to see if this is the first setup or not.
class TaintSetup
  include StaticConfigurations
  def initialize
  end

  def execute
    FileUtils.touch TaintFile
  end
end
end
