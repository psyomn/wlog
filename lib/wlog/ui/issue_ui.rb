require 'date'
require 'readline'

require 'wlog/commands/replace_pattern'
require 'wlog/commands/new_entry'
require 'wlog/commands/make_csv'
require 'wlog/commands/innit_db'
require 'wlog/commands/concat_description'
require 'wlog/domain/sys_config'
require 'wlog/domain/timelog_helper'
require 'wlog/domain/attachment'
require 'wlog/ui/edit_handler'

module Wlog
# The interface when focusing on an issue
# @author Simon
class IssueUi
  def initialize(issue)
    @issue = issue
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
      when /^edit/      then EditHandler.new(@issue).edit_what(cmd.split.drop 1)
      when /^concat/    then concat_description
      when /^replace/   then replace_pattern
      when /^search/    then search_term((cmd.split.drop 1).join ' ')
      when /^lt/        then time(cmd.split.drop 1) # lt for log time
      when /^forget/    then cmd = "end"
      when /^finish/    then finish ? cmd = "end" : nil
      when /^showattach/ then show_attach
      when /^outattach/  then output_attach
      when /^attach/ then attach
      when /^help/      then print_help
      when /^end/       then next
      else puts "Type 'help' for help"
      end
    end
  end

  # Focusing on the current issue
  attr_accessor :issue

private 

  # Wriet out the data contained in the database of the attachment
  def output_attach
    puts "Migration of implementation pending" 
    return

    att_id = Readline.readline('Which attachment to output? : ').to_i
    loc = Readline.readline('Output where (abs dir) ? : ')
    loc.chomp!
    att = Attachment.find(@db, Issue.name, att_id)
    
    fh = File.open("#{loc}/#{att.filename}", 'w')
    fh.write(att.data)
    fh.close
  end

  def show_attach
    puts "Migration of implementation pending" 
    return
    issue_id = Readline.readline('Which issue id? : ').to_i
    atts = Attachment.find_all_by_discriminator(@db, Issue.name, issue_id)
    atts.each do |att| 
      printf "[%d] - %s (alias: %s)\n", att.id, att.filename, att.given_name
    end
  end

  def attach
    puts "Migration of implementation pending" 
    return

    issue_id = Readline.readline('Attach to issue id: ').to_i
    loc = Readline.readline('Absolute file location: ')
    loc.strip!
    name_alias = Readline.readline('Alias name for file (optional): ')
    name_alias.strip!
    
    unless loc.nil?
      fh = File.open(loc, "r")
      data = fh.read
      fh.close

      att = Attachment.new(@db, Issue.name, issue_id)
      att.data       = data
      att.filename   = loc.split('/').last
      att.given_name = name_alias
      att.insert
      puts 'Attached file.'
    else
      puts 'You need to provide a proper path.'
    end
  end

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
    'showattach', 'Show what files have been attached to an issue',
    'outattach', 'Extract a file from the database',
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
      @issue.save
    end
  ret end
 
  # new entry command
  def new_entry
    description = Readline.readline("Enter new issue:#{$/}  ")
    description.chomp!
    @issue.mark_working!
    @issue.save
    NewEntry.new(description, @issue).execute
  end

  def delete_entry
    id = Readline.readline('Remove task log with id : ').to_i
    LogEntry.delete(id)
  end

  # Concatenate an aggregate description to a previous item
  def concat_description
    id = Readline.readline("ID of task to concatenate to: ").to_i
    str = Readline.readline("Information to concatenate: ").chomp
    ok = ConcatDescription.new(id, str).execute
    puts "No such issue" if !ok
  end

  # Replace a pattern from a description of a log entry
  def replace_pattern
    id = Readline.readline("ID of task to perform replace: ").to_i
    old_pattern = Readline.readline('replace : ').chomp
    new_pattern = Readline.readline('with    : ').chomp
    ok = ReplacePattern.new(id, old_pattern, new_pattern).execute
    puts "No such task" if !ok
  end

  def search_term(term)
    term ||= ''
    term.chomp!
    print_entries(LogEntry.where(["description LIKE ?", "%#{term}%"]))
  end

  # TODO might need refactoring
  def show_entries
    @issue.reload
    print_entries(@issue.log_entries)
  end

  def print_entries(entries_a)
    date_collections = entries_a.group_by{|le| le.created_at.strftime("%Y-%m-%d")}
    date_collections.each_key do |date_c|
    print @strmaker.green("#{date_c} - ")
    print @strmaker.yellow(date_collections[date_c].first.created_at.strftime("%A"))
    puts " [#{@strmaker.magenta(date_collections[date_c].count.to_s)}]"
      date_collections[date_c].each do |le|
        puts "  #{le}"
      end
    end
  end
end
end # end module

