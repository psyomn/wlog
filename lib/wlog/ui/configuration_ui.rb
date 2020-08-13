require 'readline'
require 'wlog/domain/sys_config'

module Wlog
  # Ui to manage configuration settings
  # @author Simon Symeonidis
  class ConfigurationUi
    # Default init
    def initialize
      @strmaker = SysConfig.string_decorator
    end

    # launch the ui
    def run
      cmd = 'default'
      label = @strmaker.yellow('config')
      until cmd == 'end'
        cmd = Readline.readline("[#{label}] ") || 'end'
        cmd.chomp!

        case cmd
        when /^show/ then show_configurations
        when /^set/  then set(cmd)
        when /^help/ then help
        end
      end
    end

    private

    # This should show the configurations
    def show_configurations
      SysConfig.read_attributes.each do |name, value|
        puts format('%s %s', @strmaker.green(name), value)
      end
    end

    # Simply, to show the possible actions on this particular Ui
    def help
      Commands.each_pair do |k, v|
        puts k
        puts "  #{v}"
      end
    end

    # Set a value to something else
    def set(cmd)
      arr = cmd.split
      if arr.size != 3
        puts 'Wrong number of arguments'
        return
      end
      cmd, key, value = arr
      SysConfig.store_config(key, value)
    end

    Commands = {
      'show' => 'shows the current configurations',
      'set <key> <value>' => 'set the configuration pair'
    }.freeze
  end
end # module wlog
