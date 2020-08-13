require 'active_record'
require 'wlog/domain/log_entry'

module Wlog
  # The invoice domain object - use this to manipulate invoice recordings, or
  # this along with some renderer and templates in order to create said invoices.
  # @author Simon Symeonidis
  class Invoice < ActiveRecord::Base
    def log_entries_within_dates
      LogEntry.where(created_at: from..to)
    end
  end
end
