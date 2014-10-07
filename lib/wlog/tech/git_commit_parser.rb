require 'wlog/domain/git_commit'
module Wlog
# Parses git text from a `git log` command invocation
# @author Simon Symeonidis
class GitCommitParser
  # @param log_s is the string obtained from running a `git log` command
  # @return a list of GitCommit objects
  def self.parse(log_s)
    cur = nil 
    inmessage = false 
    gitlogs = [] 
     
    log_s.lines.each do |line| 
      case line
      when /^commit/i
        inmessage = false 
        gitlogs.push cur if cur
        cur = GitCommit.new
        cur.commit = line.split[1].strip
                            
      when /^author/i
        cur.author = line.split[1].strip
                                   
      when /^date/i, /^\n$/
        next
                                          
      else 
        if inmessage
          cur.message.concat(line)
          cur.message.strip!
        else
          cur.shortlog = line
          cur.shortlog.strip! 
          inmessage = true
        end 
      end
    
    end
    
    gitlogs.push cur if cur
  gitlogs end

end
end
