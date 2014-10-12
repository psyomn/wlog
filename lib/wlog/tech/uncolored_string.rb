module Wlog
# Use this if the system does not support colored strings.
# @author Simon Symeonidis 
class UncoloredString # :nodoc:
  def self.red(str); str end
  def self.yellow(str); str end
  def self.magenta(str); str end
  def self.green(str); str end
  def self.blue(str); str end
  def self.white(str); str end
  def self.black(str); str end
  def self.cyan(str); str end
end
end
