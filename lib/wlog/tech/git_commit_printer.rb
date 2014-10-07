require 'wlog/domain/sys_config'
module Wlog
# Cute printer for git commit logs
# @author Simon Symeonidis
module GitCommitPrinter

  def print_git_commits(commit_a)
    sm = SysConfig.string_decorator 
    
    commit_a.each do |commit| 
      print '  '
      print sm.blue(commit.commit)
      print ' ' 
      puts  sm.green(commit.shortlog[0..50] + ' ...')
    end
  nil end

end
end
