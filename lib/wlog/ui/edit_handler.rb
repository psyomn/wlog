require 'wlog/domain/sys_config'

module Wlog
# Provides a bunch of edit helping functions for altering already inserted
# information about issues.
#
# @author Simon Symeonidis
class EditHandler

  def initialize(issue)
    @issue = issue 
    @strmaker = SysConfig.string_decorator
  end

  # Command comes in as edit <...>. This definition will check what comes
  # next and invoke the proper method to execute.
  def edit_what(terms_a)
    param = (terms_a.drop 1).join ' '

    case terms_a[0]
    when /^title/
      @issue.update(:description => param)

    when /^desc/
      @issue.update(:long_description => param)

    when /^due/
      edit_time(param)

    when /^reported/
      edit_reported_time(param)

    else 
      $stdout.puts "Usage: "
      $stdout.puts "  edit title - to edit the title"
      $stdout.puts "  edit desc  - to edit the long description"
      $stdout.puts "  edit due   - to edit the due date"
      $stdout.puts "  edit time  - to edit the time"
    end
  end
  
  # Small helper to parse the due date when editing the dates of issues.
  #   Accepted formats should be like Oct 28.
  # @param time is the date-time in string format (eg Oct 28)
  def edit_time(time)
    date_time = time_handle(time)
    @issue.update(:due_date => date_time)
    puts @strmaker.green('Updated due date')
  rescue ArgumentError
    $stderr.puts @strmaker.red \
      "Invalid date/time format. Try format like 'Oct 28'"
  end

  # Edit the reported date of an issue, given a date string in the format of
  #   'Oct 28'.
  # @param time_str is the time in string format
  def edit_reported_time(time_str)
    date_time = time_handle(time_str)
    @issue.reported_date = date_time.to_time
    @issue.update
    puts @strmaker.green('Updated reported date')
  rescue ArgumentError
    $stderr.puts @strmaker.red \
      "Invalid date/time format. Try format like 'Oct 28'"
  end

  # TODO fix me 
  # @param time_str The time that we want to kind of sanitize
  # @return a Time object which is set to 9am on that day if no time 
  #   is provided
  def time_handle(time_str)
    date_time = DateTime.parse(time_str)
    date_time = DateTime.parse(time_str + ' 9:00') if date_time.hour == 0
  end

  # Pass the issue from the previous ui to this one. This ui modifies
  attr :issue

end
end # wlog 
