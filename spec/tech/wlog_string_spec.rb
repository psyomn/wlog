require 'wlog/tech/wlog_string'
require 'wlog/tech/ansi_colors'

include Wlog

describe WlogString do
  before(:all) do
    @str = WlogString
  end

  it 'should write in red' do
    @str.red('').should match(/^\x1b\[31/)
    @str.red('').should match(/\x1b\[0m$/)
  end

  it 'should write in green' do
    @str.green('').should match(/^\x1b\[32/)
    @str.green('').should match(/\x1b\[0m$/)
  end

  it 'should write in blue' do
    @str.blue('').should match(/^\x1b\[34/)
    @str.blue('').should match(/\x1b\[0m$/)
  end

  it 'should write in yellow' do
    @str.yellow('').should match(/^\x1b\[33/)
    @str.yellow('').should match(/\x1b\[0m$/)
  end

  it 'should write in white' do
    @str.white('').should match(/^\x1b\[37/)
    @str.white('').should match(/\x1b\[0m$/)
  end

  it 'should write in cyan' do
    @str.cyan('').should match(/^\x1b\[36/)
    @str.cyan('').should match(/\x1b\[0m$/)
  end

  it 'should write in magenta' do
    @str.magenta('').should match(/^\x1b\[35/)
    @str.magenta('').should match(/\x1b\[0m$/)
  end
end
