require 'log_entry.rb'

# Author :: Simon Symeonidis
class CliInterface

  # Run the interface
  def run
    cmd = "default"
    until cmd == "end" do 
      cmd = $stdin.gets.chomp!

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

      when "help"
        print_help
      end
    end
  end

private 

  # Print the help of the cli app
  def print_help
    ["new",   "Create a new log entry", 
    "outcsv", "Export everything to CSV",
    "help",   "print this dialog",
    "end",    "Exit the progam",
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
    date_collections.each_key do |k|
    print "\x1b[32;1m#{k}\x1b[0m - "
    puts  "\x1b[33;1m#{date_collections[k].first.date.strftime("%A")}\x1b[0m "
      date_collections[k].each do |le|
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
      str.concat(key).concat("\n")
      value.each do |entry|
      str.concat(",\"#{entry.description}\",#{entry.date.strftime("%A")}\n")
      end
    end
    str
  end

end
