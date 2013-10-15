require 'wlog/commands/replace_pattern'
require 'wlog/commands/new_entry'
require 'wlog/commands/make_csv'
require 'wlog/commands/innit_db'
require 'wlog/commands/concat_description'

module Wlog
# The interface when focusing on an issue
# @author Simon
class IssueUi
  def initialize(issue)
    @issue = issue
  end

  # Start up the interface
  def run
    cmd = "default"
    until cmd == "end" do
      print "[issue ##{@issue.id}] "
      cmd = $stdin.gets || ""
      cmd.chomp!

      case cmd
      when /attach/  then attach
      when /new/     then new_entry
      when /show/    then show_entries
      when /desc/    then describe_issue
      when /delete/  then delete_entry
      when /search/  then search_term
      when /concat/  then concat_description
      when /replace/ then replace_pattern
      when /search/  then search_term
      when /forget/  then cmd = "end"
      when /finish/  then finish.nil? ? nil : cmd = "end"
      when /help/    then print_help
      else puts "Type 'help' for help"
      end
    end
  end

  # Focusing on the current issue
  attr_accessor :issue

private 

  # Print the description of the issue
  def describe_issue; puts @issue end

  def attach
  end

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
    print "Are you done with this task? [yes/no] : "
    if ret = !!$stdin.gets.match(/^yes/i)
      @issue.mark_finished!
      @issue.update
    end
  ret end
 
  # new entry command
  def new_entry
    print "Enter new issue:#{$/}  "
    description = $stdin.gets.chomp!
    @issue.mark_working!
    @issue.update
    NewEntry.new(description, @issue.id).execute
  end

  def delete_entry
    print "Remove task with id: "
    LogEntry.delete($stdin.gets.to_i)
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

  def search_term
    print "Term to search: "
    term = $stdin.gets.chomp!
    print_entries(LogEntry.search_descriptions(term))
  end

  # TODO might need refactoring
  def show_entries
    entries_arr = LogEntry.find_all_by_issue_id @issue.id
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
end
end # end module

