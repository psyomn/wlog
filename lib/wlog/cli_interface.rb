require 'turntables'
require 'wlog/log_entry.rb'
require 'wlog/helpers'
require 'wlog/static_configurations'

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
      when "new"
        puts "Enter work description:"
        print "  "
        new_entry_command
        puts "ok"

      when "show"
        puts "Showing latest log entries" 
        show_entries_command

      when "outcsv"
        puts "Exporting to CSV."
        fh = File.open("out.csv", "w")
        fh.write(make_csv)
        fh.close

      when "delete"
        print "Remove task with id: "
        delete_entry_command

      when "search"
        search_term

      when "concat" 
        concat_description

      when "replace"
        replace_pattern

      when "help"
        print_help
      end
    end
  end

  # TODO the commands should be factored out
  def self.list_databases_command
    puts "Available Worklog databases: "
    Dir["#{StaticConfigurations::DATA_DIRECTORY}*"].each do |dir|
      print "[%8d bytes]" % File.size(dir)
      print "  "
      print n
      puts
    end
  end

private 

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
    description = $stdin.gets.chomp!
    log_entry = LogEntry.new
    log_entry.description = description
    log_entry.insert
  end

  def show_entries_command
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
    LogEntry.delete($stdin.gets.to_i)
  end

  def make_csv
    str = String.new
    LogEntry.find_all.group_by{|el| el.date.strftime("%Y-%m-%d")}.each_pair do |key,value|
      str.concat("#{value.first.date.strftime("%A")} #{key}\n")
      value.each do |entry|
        str.concat(",\"#{Helpers.break_string(entry.description,80)}\"")
        str.concat($/)
      end
      str.concat($/)
    end
    str
  end

  # Concatenate an aggregate description to a previous item
  def concat_description
    print "ID of task to concatenate to: "
    id = $stdin.gets.to_i
    log_entry = LogEntry.find(id)
    print "Information to concatenate: "
    str = $stdin.gets.chomp!
    log_entry.description.concat(str)
    log_entry.update
  end

  # Replace a pattern from a description of a log entry
  def replace_pattern
    print "ID of task to perform replace: "
    id       = $stdin.gets.to_i
    print "replace : "
    old_pattern = $stdin.gets.chomp!
    print "with    : "
    new_pattern = $stdin.gets.chomp!

    log_entry = LogEntry.find(id)
    log_entry.description.gsub!(old_pattern, new_pattern)
    log_entry.update
  end

  # Call turntables to take care of the database
  def init_db
    p "init"
    current_dir = "#{File.expand_path File.dirname(__FILE__)}/sql"
    turntable   = Turntables::Turntable.new
    turntable.register(current_dir)
    turntable.make_at!("#{DATA_DIRECTORY}/#{ARGV[0] || DEFAULT_DATABASE}")
  end
end
end # module Wlog
