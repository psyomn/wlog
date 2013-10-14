require 'turntables'
require 'wlog/domain/issue'
require 'wlog/domain/static_configurations'
require 'wlog/domain/sys_config'
require 'wlog/commands/innit_db'
require 'wlog/ui/commands/create_issue'
require 'wlog/ui/issue_ui'

module Wlog
# @author Simon Symeonidis
# Command line interface to the application. The architectural commands are
# included here, and should be factored out in the future.
class CliInterface
  include StaticConfigurations

  # This is the main entry point of the application. Therefore when we init,
  # we want to trigger the table creation stuff.
  def initialize; InnitDb.new.execute end

  # Run the interface
  def run
    cmd = "default"
    until cmd == "end" do 
      print "[wlog] "
      cmd = $stdin.gets || "end"
      cmd.chomp!

      case cmd
      when /focus/  then focus
      when /new/    then new_issue
      when /show/   then show_issues
      when /outcsv/ then outcsv
      when /delete/ then delete_entry
      when /help/   then print_help
      end
    end
  end
  
  # TODO this might need to be factored out elsewhere
  def self.list_databases
    puts "Available Worklog databases: "
    Dir["#{StaticConfigurations::DataDirectory}*"].each do |db|
      puts "[%8d bytes] %s" % [File.size(db), db]
    end
  end

private 
 
  # Create a new issue
  def new_issue; CreateIssue.new.execute end

  def focus
    puts "Focus on issue: "
    issue_id = $stdin.gets.to_i
    issue = Issue.find(issue_id)
    SysConfig.last_focus = issue.id if issue
    IssueUi.new(issue).run
  end

  def outcsv
    puts "Exporting to CSV."
    fh = File.open("out.csv", "w")
    fh.write(make_csv)
    fh.close
  end

  # Print the help of the cli app
  def print_help
    ["new",   "Create a new log entry", 
    "outcsv", "Export everything to CSV",
    "help",   "print this dialog",
    "end",    "Exit the progam",
    "delete", "Remove the issue with a given id"].each_with_index do |el,ix| 
      print "  " if 1 == ix % 2
      puts el
    end
  end

  # TODO might need refactoring
  def show_issues
    entries_arr = Issue.find_all
    issue_collections = entries_arr.reverse.group_by{|iss| iss.status_s}
    issue_collections.each_key do |stat|
      print "\x1b[32;1m#{stat}\x1b[0m"
      puts " [\x1b[35;1m#{issue_collections[stat].count}\x1b[0m]"
      issue_collections[stat].each do |iss|
        puts "  [#{iss.id}] #{iss.description}"
      end
    end
  end

  def make_csv
    cmd = MakeCsv.new
    cmd.execute
    cmd.ret
  end
end
end # module Wlog

