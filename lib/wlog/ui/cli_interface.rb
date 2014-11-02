require 'readline'
require 'wlog/domain/issue'
require 'wlog/domain/static_configurations'
require 'wlog/domain/sys_config'
require 'wlog/domain/helpers'

require 'wlog/commands/create_issue'
require 'wlog/ui/configuration_ui'

require 'wlog/commands/archive_issues'
require 'wlog/commands/archive_finished_issues'
require 'wlog/commands/delete_issue'
require 'wlog/ui/issue_ui'
require 'wlog/ui/template_ui'
require 'wlog/ui/invoice_ui'
require 'wlog/ui/git_ui'

module Wlog
# @author Simon Symeonidis
# Command line interface to the application. The architectural commands are
# included here, and should be factored out in the future.
class CliInterface
  include StaticConfigurations

  # This is the main entry point of the application. Therefore when we init,
  # we want to trigger the table creation stuff.
  def initialize
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
      when /^archive/ then archive cmd
      when /^focus/  then focus(cmd)
      when /new/    then new_issue
      when /^(ls|show)/   then show_issues
      when /^outcsv/ then outcsv
      when /^delete/ then delete_issue(cmd)
      when /^help/   then print_help
      when /^search/ then search
      when /^config/ then config
      when /^git/ then GitUi.new.run
      when /^templates/ then TemplateUi.new.run
      when /^invoices/ then InvoiceUi.new.run
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
  def new_issue; CreateIssue.new.execute end

  # Procedure to delete an issue
  def delete_issue(cmd)
    issue_id = cmd.split[1]

    if !issue_id
      puts 'usage:'
      puts '  delete <id>'
      return
    else
      issue_id = issue_id.to_i
    end

    dcmd = DeleteIssue.new(issue_id)
    if dcmd
      choice = Readline.readline("Delete issue #{issue_id}? [y/n]").strip
      if choice == "y"
        dcmd.execute
      else
        puts "Did nothing"
        return
      end
    end

    puts "No such issue" unless dcmd.deleted?
  end
  # Archive means set status to 3 (arhive status) to the listed issues
  def archive(cmd)
    args = cmd.split[1..-1]

    if args.length > 0
      if args[0] == 'finished'
        puts "Archiving finished issues."
        ArchiveFinishedIssues.new.execute
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

  # Focus on an issue to log work etc
  def focus(cmd)
    issue_id = cmd.split[1]
    if !issue_id
      puts 'usage: '
      puts '  focus <id>'
      return
    else
      issue_id = issue_id.to_i
    end

    issue = Issue.find(issue_id)
    if issue
      IssueUi.new(issue).run
    end
  rescue ActiveRecord::RecordNotFound
    puts "No such issue"
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
    ['new',   'Create a new log entry',
    'outcsv', 'Export everything to CSV',
    'help',   'print this dialog',
    'end',    'Exit the progam',
    'delete', 'Remove the issue with a given id',
    'archive', 'Archive a file into a specific issue',
    'invoices', 'Go to invoices interface',
    'templates', 'Go to template interface, and set templates',
    'git', 'Go git interface for setting git options',
    'focus', 'Focus on a particular ',
    'show', 'List all the issues',
    'help', 'Show this information',
    'search', 'Search for a specific text',
    'config', 'Set differeing configuration parameters'
    ].each_with_index do |el,ix|
      print '  ' if 1 == ix % 2
      puts el
    end
  end

  def show_issues
    entries_arr = Issue.find_not_archived
    print_list(entries_arr)
  end

  def print_list(entries_arr)
    issue_collections = entries_arr.reverse.group_by{|iss| iss.status_s}
    issue_collections.each_key do |stat|
      print_date_collection(stat, issue_collections)
    end
  end

  def print_date_collection(stat, issues)
    print @strmaker.green("#{stat}")
    puts @strmaker.magenta(" #{issues[stat].count}")
    issues[stat].each do |iss|
      print_issue(iss)
    end
  end

  def print_issue(issue)
    print @strmaker.red("  [#{issue.id}] ")
    puts "#{issue.description}"
  end

  def make_csv
    cmd = MakeCsv.new
    cmd.execute
    cmd.ret
  end

  # Search for an issue
  def search
    term = Readline.readline("search issues for term : ")
    issues = Issue.where(["description like ?", "%#{term}%"])
    print_list(issues)
  end

  # Run the configuration Ui
  def config; ConfigurationUi.new.run end

end
end # module Wlog
