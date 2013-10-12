require 'turntables'
require 'wlog/log_entry'
require 'wlog/helpers'
require 'wlog/static_configurations'

require 'wlog/commands/innit_db'
require 'wlog/commands/replace_pattern'
require 'wlog/commands/new_entry'

module Wlog
# @author Simon Symeonidis
# Command line interface to the application. The architectural commands are
# included here, and should be factored out in the future.
class CliInterface
  include StaticConfigurations

  # This is the main entry point of the application. Therefore when we init,
  # we want to trigger the table creation stuff.
  def initialize
    init_db
  end

  # Run the interface
  def run
    cmd = "default"
    until cmd == "end" do 
      print "[wlog::] "
      cmd = $stdin.gets
      cmd ||= "end"
      cmd.chomp!

      case cmd
      when /new/  then new_entry_command
      when /show/ then show_entries_command

      when /outcsv/

      when /delete/  then delete_entry_command
      when /search/  then search_term
      when /concat/  then concat_description
      when /replace/ then replace_pattern
      when /help/    then print_help
      end
    end
  end

  def self.list_databases_command
    puts "Available Worklog databases: "
    Dir["#{StaticConfigurations::DataDirectory}*"].each do |dir|
      print "[%8d bytes]" % File.size(dir)
      print "  "
      print n
      puts
    end
  end

private 

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
    "concat", "Add a string at the end of a previous entry",
    "end",    "Exit the progam",
    "search", "Search for a string in the log description text",
    "delete", "Remove the task with a given id"].each_with_index do |el,ix| 
      print "  " if 1 == ix % 2
      puts el
    end
  end

  # new entry command
  def new_entry_command
    puts "Enter work description:"
    print "  "
    description = $stdin.gets.chomp!
    NewEntry.new(description).execute
    puts "ok"
  end

  def show_entries_command
    puts "Showing latest log entries" 
    print_entries(LogEntry.find_all)
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

  def search_term
    print "Term to search: "
    term = $stdin.gets.chomp!
    print_entries(LogEntry.search_descriptions(term))
  end

  def delete_entry_command
    print "Remove task with id: "
    LogEntry.delete($stdin.gets.to_i)
  end

  def make_csv
    cmd = MakeCsv.new
    cmd.execute
    cmd.ret
  end

  # Concatenate an aggregate description to a previous item
  def concat_description
    print "ID of task to concatenate to: "
    id = $stdin.gets.to_i
    print "Information to concatenate: "
    str = $stdin.gets.chomp!
    ConcatDescription.new(id, str).execute
  end

  # Replace a pattern from a description of a log entry
  def replace_pattern
    print "ID of task to perform replace: "
    id       = $stdin.gets.to_i
    print "replace : "
    old_pattern = $stdin.gets.chomp!
    print "with    : "
    new_pattern = $stdin.gets.chomp!
    ReplacePattern.new(id, old_pattern, new_pattern).execute
  end

  # Call turntables to take care of the database
  def init_db; InnitDb.new.execute end
end
end # module Wlog

