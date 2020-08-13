require 'wlog/domain/static_configurations'

module Wlog
  # This contains a few helper methods that may be used by any part in the
  # application.
  # @author Simon Symeonidis
  class Helpers
    include StaticConfigurations
    # Break the string to a different line
    # @param string is the string that we want processed.
    # @param numchars is the amount of characters max per line.
    def self.break_string(string, numchars)
      return unless string

      desc = ''
      cl = 0
      string.split.each do |word|
        wlength = word.length
        if cl + wlength + 1 > numchars
          cl = 0
          desc.concat($/)
        end
        desc.concat(word).concat(' ')
        cl += wlength + 1
      end
      desc.chomp!
      desc end

    # Check to see if the database exists in the DataDirectory
    # @return true if exists, otherwise false
    def self.database_exists?
      File.exist? "#{DataDirectory}#{DefaultDb}"
    end

    # Check to see if DataDirectory exists
    # Create the data directory if it does not exist.
    def self.make_dirs!
      # Does the data dir path not exist?
      FileUtils.mkdir_p DataDirectory unless File.exist? DataDirectory
      nil end

    # Check if the application directory exists. If it does not, it's a first
    # time system run.
    def self.first_setup?
      !File.exist? TaintFile
  end
  end
end # module Wlog
