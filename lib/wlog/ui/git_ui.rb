require 'wlog/domain/sys_config'
module Wlog
# Interface to setup git stuff.
# @author Simon Symeonidis
class GitUi
  
  def initialize
    @strmaker = SysConfig.string_decorator
  end

  def run 
    cmd = "default" 

    until cmd == "end" do 
      cmd = Readline.readline("[#{@strmaker.blue('git')}] ")

      case cmd 
      when /^set/
        path = Readline.readline("Path to git repo (eg: project/.git/): ")
        
        unless File.directory? path
          puts @strmaker.red("That doesn't look like a git repo. Nothing done")
          next
        end
 
        # Set the git repo in the db (so one git repo per db)
        KeyValue.put!("git", path)

      when /^unset/
        KeyValue.put!("git", "")

      when /^(ls|show)/
        print '  '
        puts @strmaker.green(KeyValue.get("git"))

      end
    end
  end

end
end

