require 'wlog/domain/key_value'
require 'wlog/domain/static_configurations'
require 'wlog/tech/wlog_string'
require 'wlog/tech/uncolored_string'

module Wlog
# System preferences helper, that stores last accessed stuff and other fluff.
# @author Simon Symeonidis
class SysConfig

  def initialize(db)
    @db = db
    @key_value = KeyValue.new(@db)
  end

  # load the last focused issue
  def last_focus
    @key_value.get('last_focus')
  end

  # store the last focused issue
  def last_focus=(issue)
    @key_value.put!('last_focus', "#{issue}")
  end

  def self.ansi?
    self.read_attributes['ansi'] == 'yes'
  end

  def self.not_ansi!
    self.store_config('ansi', 'no')
  end

  def self.ansi!
    self.store_config('ansi', 'yes')
  end

  # Store a term into the configuration file
  def self.store_config(term,value)
    values = self.read_attributes
    values[term] = value
    self.write_attributes(values)
  end

  # Get a term from the configuration file. Return nil if not found
  def self.get_config(term)
    self.read_attributes[term]
  end

  # Get the string decorator.
  def self.string_decorator
    if self.ansi?
      WlogString
    else
      UncoloredString
    end
  end

  attr_accessor :db

  # terms is a hash -> {:a => :b, :c => :d}
  # write each key value to a file like this:
  #   a:b
  #   c:d
  #   ...
  def self.write_attributes(terms)
    include StaticConfigurations
    str = terms.inject(""){|str,e| str += "#{e[0]}:#{e[1]}#{$/}"}
    fh = File.open(ConfigFile, 'w')
    fh.write(str)
    fh.close
  end

  # Load a hash from a text file.
  # @see self.write_attributes
  def self.read_attributes
    include StaticConfigurations
    FileUtils.touch ConfigFile
    lines = File.open(ConfigFile, 'r').read.split(/#{$/}/)
    terms = lines.map{|e| e.split(':')}
    values = Hash.new(nil)
    terms.each do |term_tuple| # [term, value]
      values[term_tuple[0]] = term_tuple[1]
    end
  values end

  attr :key_value

end
end # module Wlog

