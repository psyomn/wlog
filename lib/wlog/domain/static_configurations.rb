module Wlog
  # Static path data.
  #
  # Please follow the convention that if vars are dirs, then they end with '/'
  #
  # @author  Simon Symeonidis
  module StaticConfigurations
    # The application name
    AppName = 'wlog'.freeze

    # Absolute path to the configuration directory
    ConfigDirectory = "#{ENV['HOME']}/.config/".freeze

    # Absolute path to the application directory
    AppDirectory = "#{ConfigDirectory}#{AppName}/".freeze

    # Absolute path to the data directory
    DataDirectory = "#{AppDirectory}data/".freeze

    # Default database name (when unspecified)
    DefaultDb = (ARGV[0] || 'default').to_s.freeze

    # Where the template files exist
    TemplateDir = "#{AppDirectory}templates/".freeze

    # Sample file to provide the user with
    TemplateSampleFile = "#{TemplateDir}/default.erb".freeze

    # In the future if someone wants to code an alternative, go ahead
    TemplateOutputDir = "#{ENV['HOME']}/Documents/wlog/#{DefaultDb}/".freeze

    # This is used to see if it is the first setup or not
    TaintFile = "#{AppDirectory}tainted".freeze

    # The configuration file
    ConfigFile = "#{AppDirectory}config".freeze
  end
end # module Wlog
