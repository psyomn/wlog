module Wlog
# @author Simon Symeonidis
# @date Wed Jul 10 17:37:24 EDT 2013
# This contains a few helper methods that may be used by any part in the 
# application.
class Helpers

  # Break the string to a different line 
  # @param string is the string that we want processed.
  # @param numchars is the amount of characters max per line.
  def self.break_string(string,numchars)
    desc = "" 
    cl = 0
    string.split.each do |word|
      if cl + word.length + 1 > numchars
        cl = 0
        desc.concat($/)
      end
      desc.concat(word).concat(" ")
      cl += word.length + 1
    end

    desc.chomp!
    desc
  end

end
end # module Wlog
