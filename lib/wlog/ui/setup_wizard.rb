require 'wlog/domain/sys_config'
require 'wlog/commands/taint_setup'
module Wlog
# This is the ui that is displayed whenever we detect that it is the first
# time that the application runs.
# @author Simon Symeonidis
class SetupWizard
  def initialize(db)
    @db = db
  end

  # Call this to prompt the user for things
  def run
    input = ""
    until ['yes', 'no'].include? input
      puts "Do you use a terminal that supports ANSI colors? [yes/no] :"
      input = $stdin.gets
      input.chomp!
    end
    SysConfig.store_config('ansi', input)
    TaintSetup.new.execute
  end
end
end
