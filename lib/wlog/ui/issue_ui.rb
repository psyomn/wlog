require 'wlog/commands/replace_pattern'
require 'wlog/commands/new_entry'
require 'wlog/commands/make_csv'
require 'wlog/commands/innit_db'
require 'wlog/commands/concat_description'

module Wlog
# The interface when focusing on an issue
# @author Simon
class IssueUi
  def initialize
  end

  # Start up the interface
  def run
    cmd = "default"
    until cmd == "end" do
      print "[issue #__] "
      cmd = $stdin.gets || "end"
      cmd.chomp!

      case cmd
      when /new/     then new_entry
      when /show/    then show_entries
      when /delete/  then delete_entry
      when /search/  then search_term
      when /concat/  then concat_description
      when /replace/ then replace_pattern
      when /search/  then search_term
      when /forget/  then forget
      when /finish/  then finish
      when /help/    then print_help
      end
    end
  end

  # Focusing on the current issue
  attr_accessor :current_issue

private 

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
  end
 
  # Exit the issue, do not mark (still under progress)
  def forget
  end

  # new entry command
  def new_entry
    print "Enter new issue:#{$/}  "
    description = $stdin.gets.chomp!
    NewEntry.new(description).execute
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
end
end # end module

