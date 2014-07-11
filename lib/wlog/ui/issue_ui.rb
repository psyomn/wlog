require 'date'
require 'readline'

require 'wlog/commands/replace_pattern'
require 'wlog/commands/new_entry'
require 'wlog/commands/make_csv'
require 'wlog/commands/innit_db'
require 'wlog/commands/concat_description'
require 'wlog/domain/sys_config'
require 'wlog/domain/timelog_helper'

module Wlog
# The interface when focusing on an issue
# @author Simon
class IssueUi
  def initialize(db, issue)
    @issue = issue
    @db = db
    @strmaker = SysConfig.string_decorator
  end

  # Start up the interface
  def run
    cmd = "default"
    until cmd == "end" do
      cmd = Readline.readline("[issue ##{@issue.id}] ") || ""
      cmd.chomp!

      case cmd
      when /^new/       then new_entry
      when /^(ls|show)/ then show_entries
      when /^desc/      then describe_issue
      when /^delete/    then delete_entry
      when /^edit/      then edit_what(cmd.split.drop 1)
      when /^concat/    then concat_description
      when /^replace/   then replace_pattern
      when /^search/    then search_term(cmd.split.drop 1)
      when /^lt/        then time(cmd.split.drop 1) # lt for log time
      when /^forget/    then cmd = "end"
      when /^finish/    then finish.nil? ? nil : cmd = "end"
      when /^help/      then print_help
      when /^end/       then next
      else puts "Type 'help' for help"
      end
    end
  end

  # Focusing on the current issue
  attr_accessor :issue

private 

  # Time logging command
  def time(rest)
    time = TimelogHelper.parse(rest.join) 
    @issue.log_time(time)
    puts @strmaker.green('logged time!')
  end

  # Print the description of the issue
  def describe_issue; puts @issue end

  # This needs updating
  def print_help
    ["new",   "Create a new log entry", 
    "outcsv", "Export everything to CSV",
    "help",   "print this dialog",
    "end",    "Exit the progam",
    "search", "Search for a string in the log description text",
    "delete", "Remove the task with a given id"].each_with_index do |el,ix| 
      print "  " if 1 == ix % 2
      puts el
    end
  end

  # Exit the issue, mark as finished
  def finish
    question = 'Are you done with this task? [yes/no] :'
    if ret = !! Readline.readline(question).match(/^yes/i)
      @issue.mark_finished!
      @issue.update
    end
  ret end
 
  # new entry command
  def new_entry
    description = Readline.readline("Enter new issue:#{$/}  ")
    description.chomp!
    @issue.mark_working!
    @issue.update
    NewEntry.new(@db, description, @issue.id).execute
  end

  def delete_entry
    id = Readline.readline('Remove task log with id : ').to_i
    LogEntry.delete_by_id(@db, id)
  end

  # Concatenate an aggregate description to a previous item
  def concat_description
    id = Readline.readline("ID of task to concatenate to: ").to_i
    str = Readline.readline("Information to concatenate: ").chomp
    ConcatDescription.new(@db, id, str).execute
  end

  # Replace a pattern from a description of a log entry
  def replace_pattern
    id = Readline.readline("ID of task to perform replace: ").to_i
    old_pattern = Readline.readline('replace : ').chomp
    new_pattern = Readline.readline('with    : ').chomp
    ReplacePattern.new(@db, id, old_pattern, new_pattern).execute
  end

  def search_term(term)
    term.chomp!
    print_entries(LogEntry.search_descriptions(@db, term))
  end

  # Command comes in as edit <...>. This definition will check what comes
  # next and invoke the proper method to execute.
  def edit_what(terms_a)
    case terms_a[0]
    when /^title/

    when /^desc/

    when /^due/
      date_time = terms_a.drop 1
      edit_time(date_time.join(' '))

    when /^time/
      puts "Placeholder for time"

    else 
      $stdout.puts "Usage: "
      $stdout.puts "  edit title - to edit the title"
      $stdout.puts "  edit desc  - to edit the long description"
      $stdout.puts "  edit due   - to edit the due date"
      $stdout.puts "  edit time  - to edit the time"
    end
  end
  
  # @param time is the date-time in string format (eg Oct 28)
  def edit_time(time)
    date_time = DateTime.parse(time)
    date_time = DateTime.parse(time + ' 9:00') if date_time.hour == 0
    @issue.due_date = date_time.to_time
    @issue.update
    puts @strmaker.green("Updated time")
  rescue ArgumentError
    $stderr.puts "Invalid date/time format. Try something like Oct 28"
  end

  # TODO might need refactoring
  def show_entries
    entries_arr = LogEntry.find_all_by_issue_id(@db, @issue.id)
    date_collections = entries_arr.group_by{|le| le.date.strftime("%Y-%m-%d")}
    date_collections.each_key do |date_c|
    print @strmaker.green("#{date_c} - ")
    print @strmaker.yellow(date_collections[date_c].first.date.strftime("%A"))
    puts " [#{@strmaker.magenta(date_collections[date_c].count.to_s)}]"
      date_collections[date_c].each do |le|
        puts "  #{le}"
      end
    end
  end
end
end # end module

