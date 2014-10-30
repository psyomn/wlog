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

        author = Readline.readline("git author: ")

        # Set the git repo in the db (so one git repo per db)
        KeyValue.put!("git", path)
        KeyValue.put!("author", author)

      when /^unset/
        KeyValue.put!("git", "")

      when /^(ls|show)/
        print '  repo: '
        puts @strmaker.green(KeyValue.get("git"))
        print '  auth: '
        puts @strmaker.yellow(KeyValue.get("author"))

      when /^help/
        print_help

      end
    end
  end

  def print_help
    ['set', 'sets the git repository and author',
     'unset', 'unsets the git repository and author',
     'ls', 'shows current git repository and author'

    ].each_with_index do |el,ix|
      print '  ' if 1 == ix % 2
      puts el
    end
  end

end
end
