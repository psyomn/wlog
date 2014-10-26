require 'wlog/domain/sys_config'
module Wlog

  # Use strmakers in order to color hyperlinks. This will look for a regex
  # pattern of a http(s) link, and color it.
  # @param string is the string we want to look into and color
  def highlight_hyperlink_s(string)
    @strmaker = SysConfig.string_decorator
    regex = /http(s)?:\S*|www.\S*/
    str_a = string.split.map { |e| e.match(regex) ? @strmaker.blue(e) : e }
    str_a.join ' '
  end

end

