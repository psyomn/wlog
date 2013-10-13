require 'turntables'
require 'wlog/log_entry'
require 'wlog/helpers'
require 'wlog/static_configurations'
require 'wlog/ui/create_issue'

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
      print "[wlog::] "
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
    Dir["#{StaticConfigurations::DataDirectory}*"].each do |dir|
      print "[%8d bytes]" % File.size(dir)
      puts "  #{n}"
    end
  end

private 
 
  # Create a new issue
  def new_issue; CreateIssue.new.execute end

  def focus
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


  def show_issues
    puts "Issues will be shown here"
  end

  def print_entries(entries_arr)
    date_collections = entries_arr.group_by{|le| le.date.strftime("%Y-%m-%d")}
    date_collections.each_key do |date_c|
    print "\x1b[32;1m#{date_c}\x1b[0m - "
    print "\x1b[33;1m%9s\x1b[0m " % [date_collections[date_c].first.date.strftime("%A")]
    puts "[\x1b[35;1m#{date_collections[date_c].count}\x1b[0m]"
      date_collections[date_c].each do |le|
        puts "  #{le}"
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

