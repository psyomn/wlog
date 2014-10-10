require 'readline'
require 'wlog/domain/invoice'
require 'wlog/domain/sys_config'
require 'wlog/domain/static_configurations'
require 'wlog/domain/template_helper'
require 'wlog/commands/write_template'
require 'wlog/commands/fetch_git_commits'
require 'wlog/tech/git_commit_printer'
require 'erb'

module Wlog
# An interface for the invoices
# @author Simon Symeonidis
class InvoiceUi
  include StaticConfigurations
  include GitCommitPrinter

  def initialize
    @strmaker = SysConfig.string_decorator
  end

  def run
    cmd = "default"

    while cmd != 'end'
      cmd = Readline.readline("[#{@strmaker.red('invoices')}] ") || ""
      case cmd
      when /^new/       then make_invoice
      when /^(ls|show)/ then ls
      when /^delete/    then delete(cmd.split.drop 1)
      when /^generate/  then generate(cmd.split.drop 1)
      when /^commits/   then commits(cmd.split.drop 1)
      when 'help'       then print_help
      when /^end/       then next
      else 
        puts "type 'help' for a list of options"
      end
    end
  end

private

  # TODO maybe separate this in the future for better testing.
  def generate(rest)
    num = rest.first || 1
    @invoice = Invoice.find(num.to_i)
    
    # NOTE: these need to be instance vars, so we expose them to ERB later on
    @log_entries = @invoice.log_entries_within_dates
    @issues = [Issue.find(*(@log_entries.collect(&:issue_id).uniq))].compact.flatten
    
    renderer = ERB.new(TemplateHelper.template_s)
    output = renderer.result(binding)

    WriteTemplate.new(output).execute

  rescue ActiveRecord::RecordNotFound
    puts 'No such invoice'
  rescue => e
    puts e.message
  end

  def delete(rest)
    id = rest[0]
    cmd = Readline.readline("Are you sure you want to delete invoice ##{id}? [y/n]: ")
    return if cmd != 'y' 
    Invoice.delete(id)
  end

  def ls
    Invoice.all.each do |invoice|
      print "  [#{invoice.id}] " 
      print @strmaker.yellow(invoice.from.strftime("%d-%m-%Y"))
      print @strmaker.blue(" -> ")
      print @strmaker.yellow(invoice.to.strftime("%d-%m-%Y"))
      puts " #{invoice.description.lines.first.gsub(/(\r|\n)/, "")[0..49]}..."
    end
  end

  def print_help
    ['new', 'make a new invoice',
     'ls,show', 'list the current invoice templates',
     'delete', 'delete an invoice (eg: delete 2)',
     'generate', 'generate an invoice using set template (eg: generate 2)'
    ].each_with_index do |cmd,ix|
      print '  ' if ix % 2 == 1 
      puts cmd
    end
  end

  # TODO this should be extracted for testing
  def make_invoice
    from_s = Readline.readline("#{@strmaker.blue('From')} (dd-mm-yyyy) ")
    to_s   = Readline.readline("#{@strmaker.blue('To')}   (dd-mm-yyyy) ")

    from_d = DateTime.parse(from_s)
    to_d = DateTime.parse(to_s + " 23:59")
    description = longtext()

    Invoice.create(:from => from_d, :to => to_d, :description => description)
  end

  # TODO: this would have to be factored out at some point. Also I think the
  # implementation is crappy. I have to recheck at some point.
  def longtext
   count = 0 
   status = nil
   str = ""
   
   until status == :end_text do 
     line = Readline.readline(@strmaker.blue('> ')).strip
     count += 1 if line == ""
     count  = 0 if line != ""

     str.concat(line).concat($/)
   
     status = :end_text and next if count == 2
   end 
  str end

  def commits(invoice_id)
    inv = Invoice.find_by_id(invoice_id) 
    repo = KeyValue.get('git')
    author = KeyValue.get('author')

    unless repo 
      puts @strmaker.red("You need to set a git repo first")
      return
    end

    command = FetchGitCommits.new(inv.from, inv.to, repo, author)
    command.execute

    puts
    print '  '
    puts "git commits for #{@strmaker.yellow(author)}"
    puts
    print_git_commits(command.commits)
    
  rescue ActiveRecord::RecordNotFound
    puts @strmaker.red("No such invoice")
  end

end
end

