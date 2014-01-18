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
      cmd = Readline.readline("[#{label}]") || "end"
      cmd.chomp!

      case cmd 
      when /^show/ then show_configurations
      end
    end
  end

private 

  # This should show the configurations
  def show_configurations
    puts "TODO: show configurations"
  end

end
end # module wlog
