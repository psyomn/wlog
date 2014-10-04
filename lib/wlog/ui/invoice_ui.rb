require 'readline'
require 'wlog/domain/invoice'
require 'wlog/domain/sys_config'
require 'wlog/domain/static_configurations'
require 'erb'

module Wlog
# An interface for the invoices
# @author Simon Symeonidis
class InvoiceUi
  include StaticConfigurations

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
    @issues = [Issue.find(*(@les.collect(&:issue_id).uniq))].compact.flatten
    
    # Get the template
    num        = SysConfig.get_config('template') || 1
    tpath      = Dir[TemplateDir + '*'][num.to_i - 1]
    template_s = File.read(tpath)

    renderer = ERB.new(template_s)
    output = renderer.result(binding)

    FileUtils.mkdir_p TemplateOutputDir
    template_ext = tpath.split(File::SEPARATOR).last.split('.').last
    filename = TemplateOutputDir + "#{@invoice.id}-invoice.#{template_ext}"

    File.write(filename, output)

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
    times = 3
    str = ""
    count = 0

    while times != 0 do
      cur = Readline.readline()
      str.concat(cur)
      str.concat($/)
      if ["", nil].include? cur
        str.concat($/)
        count += 1
        if count == 2
          times -= 1
          count = 0
        end
      else 
        # reset blank line count. The user will have to hammer enter a few times
        # to escape from this menu
        count = 0
      end
    end
  str end

end
end

