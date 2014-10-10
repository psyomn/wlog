require_relative '../spec_helper'

include Wlog

describe GitCommitParser do 

  GitLogSample = <<GITDATA
commit 19b5dd496ba2e4125c681b3c505f7631053a2fab
Author: psyomn <lethaljellybean@gmail.com>
Date:   Wed Oct 23 23:00:56 2013 -0400

    Tiny setup wizard for checking if ansi or not
    
    Need to provide a system configuration service that takes into account things
    that are the same for any running instance of the application (because others
    might just be specific to project databases).

commit 533f1245a8e6d4382e250518d0a9ee4b19b7657d
Author: psyomn <lethaljellybean@gmail.com>
Date:   Wed Oct 23 22:57:57 2013 -0400

    Add taint setup command.

commit 4630d627b5b5f4f114e35991daea8684fca6ddd9
Author: psyomn <lethaljellybean@gmail.com>
Date:   Wed Oct 23 22:46:27 2013 -0400

    Add setup wizard.

GITDATA

  Malformed = <<BADGIT
 potato potato potato potato potato potato potato potato potato potato potato 
potato potato potato potato potato potato potato potato potato potato potato potato 
potato potato potato potato potato potato potato potato potato potato potato potato 
potato potato potato potato potato potato potato potato potato potato potato potato 
potato potato potato potato potato potato potato potato potato potato potato potato 
BADGIT

  it 'should return [] on null string' do 
    expect(GitCommitParser.parse('')).to eq([])
  end

  it 'should return [] on malformed format' do
    expect(GitCommitParser.parse(Malformed)).to eq([])
  end

  it 'should return 3 commit logs' do
    expect(GitCommitParser.parse(GitLogSample).count).to eq(3)
  end

  it 'should retrieve hashes' do 
    commits = GitCommitParser.parse(GitLogSample)
    hashes = commits.collect &:commit
    expected_hashes = [
      '4630d627b5b5f4f114e35991daea8684fca6ddd9',
      '533f1245a8e6d4382e250518d0a9ee4b19b7657d',
      '19b5dd496ba2e4125c681b3c505f7631053a2fab']
    expect(hashes.count).to eq(3)
    expect((hashes & expected_hashes).count).to eq(3)
  end

  it 'should retrieve authors' do 
    commits = GitCommitParser.parse(GitLogSample)
    authors = commits.collect &:author
    expect(authors.count).to eq(3)
  end

  it 'should retrieve shortlogs' do 
    commits = GitCommitParser.parse(GitLogSample)
    shortlogs = commits.collect &:shortlog
    expect(shortlogs.count).to eq(3)
    # all shortlogs contain text
    expect(shortlogs.inject(true){ |sum,e| e != "" }).to be true
  end

  it 'should retrieve messages' do
    commits = GitCommitParser.parse(GitLogSample)
    messages = commits.collect &:message
    messages.reject! { |e| e == "" }
    expect(messages.count).to eq(1)
    expect(messages.inject(true){ |e| e != "" }).to be true
  end

end
