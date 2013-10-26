require 'readline'
require 'wlog/domain/sys_config'
require 'wlog/commands/taint_setup'

module Wlog
# This is the ui that is displayed whenever we detect that it is the first
# time that the application runs. Use this
# __ONLY__ for system wide configuration
# @author Simon Symeonidis
class SetupWizard
  def initialize
  end

  # Call this to prompt the user for things
  def run
    input = ""
    until ['yes', 'no'].include? input
      question = "Do you use a terminal that supports ANSI colors? [yes/no] :"
      input = Readline.readline(question)
      input.chomp!
    end
    SysConfig.store_config('ansi', input)
    TaintSetup.new.execute
  end
end
end
