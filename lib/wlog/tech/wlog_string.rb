require 'wlog/tech/ansi_colors'
module Wlog
# This should take care of multiplatform color stuff. 
class WlogString < String
  include AnsiColors

  def red; colorize(Red) end
  def yellow; colorize(Yellow) end
  def magenta; colorize(Magenta) end
  def green; colorize(Green) end
  def blue; colorize(Blue) end
  def white; colorize(White) end
  def black; colorize(Black) end
  def cyan; colorize(Cyan) end

private
  def colorize(col)
    "\x1b[#{col};1m#{self}\x1b[0m"
  end
end
end
