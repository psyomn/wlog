require 'wlog/domain/key_value'
require 'wlog/domain/static_configurations'
require 'wlog/tech/wlog_string'
require 'wlog/tech/uncolored_string'

module Wlog
  # System preferences helper, that stores last accessed stuff and other fluff.
  # @author Simon Symeonidis
  class SysConfig
    def initialize
      @key_value = KeyValue
    end

    # load the last focused issue
    def last_focus
      @key_value.get('last_focus')
    end

    # store the last focused issue
    def last_focus=(issue)
      @key_value.put!('last_focus', issue.to_s)
    end

    # Are the settings set to ansi?
    def self.ansi?
      read_attributes['ansi'] == 'yes'
    end

    # Oh no! The settings are not ansi!
    def self.not_ansi!
      store_config('ansi', 'no')
    end

    # SET THE SETTINGS TO ANSI!
    def self.ansi!
      store_config('ansi', 'yes')
    end

    # Store a term into the configuration file
    def self.store_config(term, value)
      values = read_attributes
      values[term] = value
      write_attributes(values)
    end

    # Get a term from the configuration file. Return nil if not found
    def self.get_config(term)
      read_attributes[term]
    end

    # Get the string decorator.
    def self.string_decorator
      if ansi?
        WlogString
      else
        UncoloredString
      end
    end

    # terms is a hash -> {:a => :b, :c => :d}
    # write each key value to a file like this:
    #   a:b
    #   c:d
    #   ...
    def self.write_attributes(terms)
      include StaticConfigurations
      str = terms.inject('') { |str, e| str += "#{e[0]}:#{e[1]}#{$/}" }
      fh = File.open(ConfigFile, 'w')
      fh.write(str)
      fh.close
    rescue Errno::ENOENT
      warn "#{self.class.name}: Problem opening file #{ConfigFile}"
    end

    # Load a hash from a text file.
    # @see self.write_attributes
    def self.read_attributes
      include StaticConfigurations
      FileUtils.touch ConfigFile
      lines = File.open(ConfigFile, 'r').read.split(/#{$/}/)
      terms = lines.map { |e| e.split(':') }
      values = Hash.new(nil)
      terms.each do |term_tuple| # [term, value]
        values[term_tuple[0]] = term_tuple[1]
      end
      values
    rescue Errno::ENOENT
      warn "#{self.class.name}: Problem opening file #{ConfigFile}"
      # Minimum guarantee: disable ansi colors
      { 'ansi' => 'no' }
    end

    # Key value domain object / helper
    attr :key_value
  end
end # module Wlog
