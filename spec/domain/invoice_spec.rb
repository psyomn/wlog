require_relative '../spec_helper'
require_relative '../make_db'

include Wlog

describe Invoice do
  include DomainHelpers

  db_name = 'default'
  db_path = standard_db_path(db_name)

  before :all do
    make_testing_db(db_name)
  end

  after :all do
    FileUtils.rm db_path
  end

  it 'should fetch all relevant log entries between two dates' do
    invoice = Invoice.create(from: (DateTime.now - 5), to: (DateTime.now + 5))
    issue = make_issue

    10.times do
      le = make_log_entry
      le.created_at = DateTime.now - 2
      issue.log_entries << le
    end
    issue.save

    expect(invoice.log_entries_within_dates.count).to eq(10)
  end
end
