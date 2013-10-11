module Wlog
# Author   :: Simon Symeonidis 
# Licenses :: GPL v3.0 
# Static path data.
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
