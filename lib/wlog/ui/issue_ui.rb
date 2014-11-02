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
      when /^delete/    then delete_entry(cmd.split.drop 1)
      when /^edit/      then EditHandler.new(@issue).edit_what(cmd.split.drop 1)
      when /^concat/    then concat_description
      when /^replace/   then replace_pattern
      when /^search/    then search_term((cmd.split.drop 1).join ' ')
      when /^lt/        then time(cmd.split.drop 1) # lt for log time
      when /^forget/    then cmd = "end"
      when /^finish/    then finish ? cmd = "end" : nil
      when /^attachout/  then output_attach
      when /^attachls/ then show_attach
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
  # This needs updating
  def print_help
    ["new",   "Create a new log entry",
    'ls',     "list issues",
    'desc',   "describe an issue",
    'edit',   "edit fields of an issue",
    'concat', "append information to an issue",
    'replace', 'replace text within an issue',
    'lt',     'log time on an issue',
    "outcsv", "Export everything to CSV",
    'attach', 'Attach a file to the current issue',
    'attachls', 'Show what files have been attached to an issue',
    'attachout', 'Extract a file from the database',
    "help",   "print this dialog",
    "end",    "Exit the progam (alias: forget, finish)",
    "search", "Search for a string in the log description text",
    "delete", "Remove the task with a given id"].each_with_index do |el,ix|
      print "  " if 1 == ix % 2
      puts el
    end
  end
  # Wriet out the data contained in the database of the attachment
  def output_attach
    att_id = Readline.readline('Which attachment to output? : ').to_i
    loc = Readline.readline('Output where (abs dir) ? : ')
    loc.chomp!
    att = Attachment.find(att_id)

    fh = File.open("#{loc}/#{att.filename}", 'w')
    fh.write(att.data)
    fh.close
  end

  def show_attach
    atts = @issue.attachments
    atts.each do |att|
      printf "[%d] - %s (alias: %s)\n", att.id, att.filename, att.given_name
    end
  end

  def attach
    loc = Readline.readline('Absolute file location: ')
    loc.strip!
    name_alias = Readline.readline('Alias name for file (optional): ')
    name_alias.strip!

    fh = File.open(loc, "r")
    data = fh.read
    fh.close

    att = Attachment.new
    att.filename = loc.split('/').last
    att.data = data
    att.given_name = name_alias

    @issue.attachments << att

    puts 'Attached file.'
  rescue Zlib::DataError
    puts 'Problem attaching file due to wrong data'
  rescue
    puts 'You need to provide a proper path.'
  end

  # Time logging command
  def time(rest)
    time = TimelogHelper.parse(rest.join)
    @issue.log_time(time)
    puts @strmaker.green('logged time!')
  end

  # Print the description of the issue
  def describe_issue;
    puts @issue
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

  def delete_entry(cmd_a)
    case cmd_a[0]
    when /t/, /task/       then LogEntry.delete(cmd_a[1])
    when /a/, /attachment/ then Attachment.delete(cmd_a[1])
    end
    # If something gets deleted, we need to reload the issue so that the
    # relations are ok.
    @issue.reload
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
