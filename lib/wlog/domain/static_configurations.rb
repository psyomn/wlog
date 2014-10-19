module Wlog
# Static path data.
#
# Please follow the convention that if vars are dirs, then they end with '/'
#
# @author  Simon Symeonidis
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
    DefaultDb = "#{ARGV[0] || default}"

    # Where the template files exist
    TemplateDir = "#{AppDirectory}templates/"

    # Sample file to provide the user with
    TemplateSampleFile = "#{TemplateDir}/default.erb"

    # In the future if someone wants to code an alternative, go ahead
    TemplateOutputDir = "#{ENV['HOME']}/Documents/wlog/#{DefaultDb}/"

    # This is used to see if it is the first setup or not
    TaintFile = "#{AppDirectory}tainted"

    # The configuration file
    ConfigFile = "#{AppDirectory}config"
  end
end # module Wlog

