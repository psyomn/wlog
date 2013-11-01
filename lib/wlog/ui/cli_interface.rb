require 'readline'
require 'turntables'
require 'wlog/domain/issue'
require 'wlog/domain/static_configurations'
require 'wlog/domain/sys_config'
require 'wlog/domain/attachment'
require 'wlog/domain/helpers'
require 'wlog/ui/commands/create_issue'

require 'wlog/commands/archive_issues'
require 'wlog/commands/archive_finished_issues'
require 'wlog/commands/delete_issue'
require 'wlog/ui/issue_ui'

module Wlog
# @author Simon Symeonidis
# Command line interface to the application. The architectural commands are
# included here, and should be factored out in the future.
class CliInterface
  include StaticConfigurations

  # This is the main entry point of the application. Therefore when we init,
  # we want to trigger the table creation stuff.
  def initialize
    @db = DbRegistry.new(nil)
    @strmaker = SysConfig.string_decorator
  end

  # Run the interface
  def run
    cmd = "default"
    label = @strmaker.white('wlog')
    until cmd == "end" do 
      cmd = Readline.readline("[#{label}] ") || "end"
      cmd.chomp!

      case cmd
      when /archive/ then archive cmd
      when /showattach/ then show_attach
      when /outattach/  then output_attach
      when /attach/ then attach
      when /focus/  then focus
      when /new/    then new_issue
      when /show/   then show_issues
      when /outcsv/ then outcsv
      when /delete/ then delete_issue
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
  def new_issue; CreateIssue.new(@db).execute end

  # Procedure to delete an issue
  def delete_issue
    issue_id = Readline.readline('Which issue id to delete? : ').to_i
    DeleteIssue.new(@db, issue_id).execute
  end

  # Wriet out the data contained in the database of the attachment
  def output_attach
    att_id = Readline.readline('Which attachment to output? : ').to_i
    loc = Readline.readline('Output where (abs dir) ? : ')
    loc.chomp!
    att = Attachment.find(@db, Issue.name, att_id)
    
    fh = File.open("#{loc}/#{att.filename}", 'w')
    fh.write(att.data)
    fh.close
  end

  def show_attach
    issue_id = Readline.readline('Which issue id? : ').to_i
    atts = Attachment.find_all_by_discriminator(@db, Issue.name, issue_id)
    atts.each do |att| 
      printf "[%d] - %s (alias: %s)\n", att.id, att.filename, att.given_name
    end
  end

  # Archive means set status to 3 (arhive status) to the listed issues
  def archive(cmd)
    args = cmd.split[1..-1]

    if args.length > 0 
      if args[0] == 'finished'
        puts "Archiving finished issues."
        ArchiveFinishedIssues.new(@db).execute
      else # gave ids
        ids = args.map{|sids| sids.to_i}
        issues = ids.map{|id| Issue.find(@db, id)} - [nil]
        ArchiveIssues.new(issues).execute
      end
    else
      puts "usage: "
      puts "  archive finished"
      puts "  archive <id>+"
    end
  end

  def attach
    issue_id = Readline.readline('Attach to issue id: ').to_i
    loc = Readline.readline('Absolute file location: ')
    loc.chomp!
    name_alias = Readline.readline('Alias name for file (optional): ')
    name_alias.chomp!
    
    unless loc.nil?
      fh = File.open(loc, "r")
      data = fh.read
      fh.close

      att = Attachment.new(@db, Issue.name, issue_id)
      att.data       = data
      att.filename   = loc.split('/').last
      att.given_name = name_alias
      att.insert
      puts "Attached file."
    else
      puts "You need to provide a proper path."
    end
  end

  def focus
    issue_id = Readline.readline('Focus on issue : ').to_i
    issue = Issue.find(@db, issue_id)
    # FIXME
    # SysConfig.last_focus = issue.id if issue
    IssueUi.new(@db, issue).run
  end

  def outcsv
    puts "Exporting to CSV."
    fh = File.open("out.csv", "w")
    fh.write(make_csv)
    fh.close
  end

  # FIXME (update the command stuff)
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
    entries_arr = Issue.find_all(@db)
    issue_collections = entries_arr.reverse.group_by{|iss| iss.status_s}
    issue_collections.each_key do |stat|
      print @strmaker.green("#{stat}")
      puts @strmaker.magenta(" #{issue_collections[stat].count}")
      issue_collections[stat].each do |iss|
        print @strmaker.red("  [#{iss.id}] ")
        puts "#{iss.description}"
      end
    end
  end

  def make_csv
    cmd = MakeCsv.new(@db)
    cmd.execute
    cmd.ret
  end
end
end # module Wlog

