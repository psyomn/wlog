require 'wlog/domain/sys_config'
module Wlog
  # Group text filters here, for any text processing you want to do
  # @author Simon Symeonidis
  module TextFilters
    # Use strmakers in order to color hyperlinks. This will look for a regex
    # pattern of a http(s) link, and color it.
    # @param string is the string we want to look into and color
    # @return the string with ansi colored links if ansi is set.
    def highlight_hyperlink_s(string)
      @strmaker = SysConfig.string_decorator
      regex = /http(s)?:\S*|www.\S*/
      s = string.dup
      tmp = nil
      s.gsub!(regex) { @strmaker.blue($&) }
      s
    end
  end
end
