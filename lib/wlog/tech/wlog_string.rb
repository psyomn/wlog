require 'wlog/tech/ansi_colors'

module Wlog
# This should take care of multiplatform color stuff.
# @author Simon Symeonidis
class WlogString
  include AnsiColors

  def self.red(str); colorize(str,Red) end
  def self.yellow(str); colorize(str,Yellow) end
  def self.magenta(str); colorize(str,Magenta) end
  def self.green(str); colorize(str,Green) end
  def self.blue(str); colorize(str,Blue) end
  def self.white(str); colorize(str,White) end
  def self.black(str); colorize(str,Black) end
  def self.cyan(str); colorize(str,Cyan) end

private
  def self.colorize(str,col)
    "\x1b[#{col};1m#{str}\x1b[0m"
  end
end
end
