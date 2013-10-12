module Wlog
# Static path data.
#
# Please follow the convention that if vars are dirs, then they end with '/'
#
# @author  Simon Symeonidis 
# @licenses GPL v3.0 
module StaticConfigurations
  # The application name
  AppName = "wlog"
  
  # Absolute path to the configuration directory
  ConfigDirectory = "#{ENV['HOME']}/.config/"

  # Absolute path to the application directory
  AppDirectory = "#{ConfigDirectory}#{AppName}/"

  # Absolute path to the data directory
  DataDirectory = "#{AppDirectory}data/"

  # Default database name (when unspecified)
  DefaultDb = "default"
end
end # module Wlog

