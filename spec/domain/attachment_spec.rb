# We'll be ignoring this for now...
#
require_relative '../spec_helper.rb'
require_relative '../make_db'
require 'wlog/domain/attachment'
require 'wlog/domain/log_entry'
require 'wlog/domain/issue'
require 'zlib'

include Wlog

describe Attachment do

   db_name = 'default'
   db_path = standard_db_path(db_name)

   before(:all) do
     make_testing_db(db_name)
   end

   after(:all) do
     close_testing_db
     FileUtils.rm db_path
   end

   it 'should attach raw data to an issue' do
     @issue = Issue.create(:description => 'mydesc',
       :long_description => 'potato')

     # You're kind of forced to do this because I've hacked a shitty
     # implementation of compressing - uncompressing strings automatically when
     # attaching files.
     @attachment = Attachment.new
     @attachment.filename = 'filename'
     @attachment.given_name = 'given name'
     @attachment.data = 'data stuff'

     @issue.attachments << @attachment
     @issue.save

     issue = Issue.find(@issue.id)
     expect(issue.attachments.count).to eq(1)
     expect(issue.attachments.first.filename).to eq('filename')
     expect(issue.attachments.first.given_name).to eq('given name')
     expect(issue.attachments.first.data).to eq('data stuff')
   end

   it 'should attach a mock file to an issue' do
     @issue = Issue.create(:description => 'issue with a mock file',
       :long_description => 'test the attachment part of things')

     # this should test strings of bytes

     @attachment = Attachment.new
     @attachment.filename = 'some-filename'
     @attachment.given_name = 'given name'

     some_random_pdf = File.read("./spec/fixtures/README.pdf")
     @attachment.data = some_random_pdf

     @issue.attachments << @attachment
     @issue.save

     issue = Issue.find(@issue.id)
     expect(issue.attachments.count).to eq(1)
     expect(issue.attachments.first.filename).to eq('some-filename')
     expect(issue.attachments.first.given_name).to eq('given name')
     expect(issue.attachments.first.data).to eq(some_random_pdf)
   end

   it "should return nil if something is not found" do
     expect(Attachment.find_by_id(123123123)).to eq(nil)
   end
end
