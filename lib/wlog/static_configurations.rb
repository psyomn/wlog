# Author   :: Simon Symeonidis 
# Licenses :: GPL v3.0 
# Static path data.
module StaticConfigurations
  # The application name
  APPLICATION_NAME        = "wlog"
  
  # Absolute path to the configuration directory
  CONFIGURATION_DIRECTORY = "#{ENV['HOME']}/.config/"

  # Absolute path to the application directory
  APPLICATION_DIRECTORY   = "#{CONFIGURATION_DIRECTORY}/#{APPLICATION_NAME}/"

  # Absolute path to the data directory
  PATH_TO_DATA            = "#{APPLICATION_DIRECTORY}/data/"

  # Default database name (when unspecified)
  DEFAULT_DATABASE        = "default"
end

