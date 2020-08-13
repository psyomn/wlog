require 'active_record'

require 'wlog/domain/log_entry'
require 'wlog/domain/timelog_helper'
require 'wlog/domain/sys_config'
require 'wlog/domain/helpers'

module Wlog
  # This aggregates log entries. The total time spent on this issue is
  # calculated from checking out said log entries.
  # @author Simon Symeonidis
  class Issue < ActiveRecord::Base
    has_many :log_entries, dependent: :delete_all
    has_many :attachments, as: :attachable

    StatusNew       = 0
    StatusStarted   = 1
    StatusFinished  = 2
    StatusArchived  = 3

    # Anything which is not archived (eg: new, started work, finished)
    def self.find_not_archived
      where('status NOT IN (?)', StatusArchived)
  end

    # Log the seconds into the issue
    def log_time(sec)
      self.timelog += sec
      save
    end

    def to_s
      le_count = log_entries.count
      @strmaker = SysConfig.string_decorator
      "#{@strmaker.yellow('Issue')} ##{id}#{$/}"\
      "  #{@strmaker.blue('Reported')} : #{created_at.asctime}#{$/}"\
      "  #{@strmaker.blue('Due')}      : #{due_date.asctime} #{make_remaining_days_s}#{$/}"\
      "  #{@strmaker.blue('Entries')}  : #{le_count} #{$/}"\
      "  #{@strmaker.blue('Status')}   : #{Statuses[status]}#{$/}"\
      "  #{@strmaker.blue('Time')}     : #{TimelogHelper.time_to_s(timelog)}#{$/}"\
      "#{$/}"\
     "#{@strmaker.yellow('Summary')} #{$/}"\
      "  #{description}#{$/ + $/}"\
     "#{@strmaker.yellow('Description')} #{$/}"\
      "  #{Helpers.break_string(long_description, 80)}#{$/ + $/}"\
      "#{@strmaker.yellow('Files')}#{$/}"\
      "#{attachments_s}"
    end

    # Mark issue as started
    def mark_started!
      self.status = 0
  end

    # Mark the issue as working
    def mark_working!
      self.status = 1
  end

    # Mark the issue as finished
    def mark_finished!
      self.status = 2
  end

    # Archive the issue
    def archive!
      self.status = 3
  end

    # Get the status as a string
    def status_s
      Statuses[status]
  end

    private

    Statuses = {
      StatusNew => 'new',
      StatusStarted => 'started work',
      StatusFinished => 'finished',
      StatusArchived => 'archived'
    }.freeze

    # Stringify attachments for terminal output
    def attachments_s
      str = ''
      attachments.each do |att|
        str.concat(att.to_s)
      end
      str = @strmaker.red("  N/A#{$/}") if str == '' # no attachments
      str.concat($/)
      str
  end

    # TODO: might need factoring out
    # Will make a string of the due date, and append the days that remain. On
    # dates before the due date, you get things like '+5 days'. Past due dates will
    # render '-5 days'
    # @return a string containing the number of days that remain
    def make_remaining_days_s
      days = (due_date.to_date - Time.now.to_date).to_i
      days_s = "[#{days} day#{days == 1 ? '' : 's'}]"
      make_colored_num_s(days, days_s)
    end

    # TODO: might need factoring out
    # Depending on the number range we color things. Uses the strmaker, so
    # terminals with no ansi support will not see anything funky :(
    # @return yellow stringified number if 1 <= x <= 3, green for more, red for
    #   less
    def make_colored_num_s(num, num_s)
      if num >= 1 && num <= 3
        @strmaker.yellow(num_s)
      elsif num < 1
        @strmaker.red(num_s)
      else
        @strmaker.green(num_s)
      end
    end

    private_class_method
  end # class  Issue
end # module Wlog
