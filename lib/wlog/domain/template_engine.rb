module Wlog
# A very simple templating engine that supports generating text files in order
# for them to be, in turn parsed by some other tool in order to generate nice
# invoices. The 'other' tool I have in mind is pandoc; this somewhat defeats
# the purpose of 'lightweight' in the sense that we indirectly need that tool,
# but on the other hand writing a more complex templating engine might prove
# too costly for now. 
# 
# @author Simon Symeonidis
class TemplateEngine

  # These can either be atomic elements, or arrays of two. In the former, they
  # just join entries by adding the separator. The latter makes the two a 
  # prefix, and postfix.
  # @param issue_sep is what to separate issues with
  # @param log_entry_sep is what to separate log entries with
  def initialize(issue_sep, log_entry_sep, issues, invoice_id)
    @issue_sep, @log_entry_sep, @issues, @invoice_id = \
      issue_sep, log_entry_sep, issues, invoice_id
  end

  def generate(filename)
    contents = File.open(filename).read
    contens.gsub(InvoiceId, @invoice_id)
  end

  # What to separate issues with
  attr_accessor :issue_sep

  # What to separate log entries with
  attr_accessor :log_entry_sep

  # An issue list
  attr_accessor :issues

private

  # The tag to look for in order to add the issue info
  IssueTag = '<issue-sep>'

  # The log entry tag to add the log entries
  LogEntrySep = '<log-entry-sep>'

  InvoiceId = '<id>'

  DateFrom = '<date-from>'

  DateTo = '<date-to>'

  StartSegment = '[segment]'
  EndSegment = '[/segment]'

end
end

