require 'readline'
require 'wlog/domain/sys_config'

module Wlog 
# Ui to manage configuration settings
# @author Simon Symeonidis
class ConfigurationUi

  def initialize
    @strmaker = SysConfig.string_decorator
  end

  def run
    cmd = "default"
    label = @strmaker.yellow('config')
    until cmd == "end" do
      cmd = Readline.readline("[#{label}] ") || "end"
      cmd.chomp!

      case cmd 
      when /^show/ then show_configurations
      when /^help/ then help
      end
    end
  end

private 

  # This should show the configurations
  def show_configurations
    SysConfig.read_attributes.each do |name, value| 
      puts "%s %s" % [@strmaker.green(name), value]
    end
  end

  # Simply, to show the possible actions on this particular Ui
  def help
    ['show', 'shows the current configurations',
    'set <key> <value>', 
    'set the configuration pair'].each_with_index do |el,ix|
      print "  " if ix % 2 == 1
      puts el
    end
  end

end
end # module wlog
