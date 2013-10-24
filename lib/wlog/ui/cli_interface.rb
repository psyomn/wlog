require 'turntables'
require 'wlog/tech/wlog_string'
require 'wlog/domain/issue'
require 'wlog/domain/static_configurations'
require 'wlog/domain/sys_config'
require 'wlog/domain/attachment'
require 'wlog/domain/helpers'
require 'wlog/commands/innit_db'
require 'wlog/ui/commands/create_issue'
require 'wlog/ui/issue_ui'
require 'wlog/ui/setup_wizard'

module Wlog
# @author Simon Symeonidis
# Command line interface to the application. The architectural commands are
# included here, and should be factored out in the future.
class CliInterface
  include StaticConfigurations

  # This is the main entry point of the application. Therefore when we init,
  # we want to trigger the table creation stuff.
  def initialize
    InnitDb.new.execute 
    @db = DbRegistry.new(nil)
    
    # Initial setup if first time running
    # SetupWizard.new(@db).run if Helpers.first_setup?
  end

  # Run the interface
  def run
    cmd = "default"
    label = WlogString.new('wlog').white
    until cmd == "end" do 
      print "[#{label}] "
      cmd = $stdin.gets || "end"
      cmd.chomp!

      case cmd
      when /showattach/ then show_attach
      when /outattach/  then output_attach
      when /attach/ then attach
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
    Dir["#{StaticConfigurations::DataDirectory}*"].each do |db|
      puts "[%8d bytes] %s" % [File.size(db), db]
    end
  end

private 
 
  # Create a new issue
  def new_issue; CreateIssue.new(@db).execute end

  # Wriet out the data contained in the database of the attachment
  def output_attach
    print "Which attachment to output? : "
    att_id = $stdin.gets.to_i
    print "Output where (abs dir) : "
    loc = $stdin.gets
    loc.chomp!
    att = Attachment.find(@db, Issue.name, att_id)
    
    fh = File.open("#{loc}/#{att.filename}", 'w')
    fh.write(att.data)
    fh.close
  end

  def show_attach
    print "Which issue : "
    issue_id = $stdin.gets.to_i
    atts = Attachment.find_all_by_discriminator(@db, Issue.name, issue_id)
    atts.each do |att| 
      printf "[%d] - %s (alias: %s)\n", att.id, att.filename, att.given_name
    end
  end

  def attach
    print "Attach to which issue? : "
    issue_id = $stdin.gets.to_i
    print "Absolute file location : "
    loc = $stdin.gets
    loc.chomp!
    print "Alias name for file (optional) :"
    name_alias = $stdin.gets
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
    puts "Focus on issue: "
    issue_id = $stdin.gets.to_i
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
      print WlogString.new("#{stat}").green
      puts WlogString.new(" #{issue_collections[stat].count}").magenta
      issue_collections[stat].each do |iss|
        print WlogString.new("  [#{iss.id}] ").red
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

