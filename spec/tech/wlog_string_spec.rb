require 'wlog/tech/wlog_string'
require 'wlog/tech/ansi_colors'

include Wlog
include AnsiColors

describe WlogString do
  before(:all) do
    @str = WlogString
  end

  it 'should write in red' do
    @str.red('').should match(/^\x1b\[#{Red}/)
    @str.red('').should match(/\x1b\[0m$/)
  end

  it 'should write in green' do
    @str.green('').should match(/^\x1b\[#{Green}/)
    @str.green('').should match(/\x1b\[0m$/)
  end

  it 'should write in blue' do
    @str.blue('').should match(/^\x1b\[#{Blue}/)
    @str.blue('').should match(/\x1b\[0m$/)
  end

  it 'should write in yellow' do
    @str.yellow('').should match(/^\x1b\[#{Yellow}/)
    @str.yellow('').should match(/\x1b\[0m$/)
  end

  it 'should write in white' do
    @str.white('').should match(/^\x1b\[#{White}/)
    @str.white('').should match(/\x1b\[0m$/)
  end

  it 'should write in cyan' do
    @str.cyan('').should match(/^\x1b\[#{Cyan}/)
    @str.cyan('').should match(/\x1b\[0m$/)
  end

  it 'should write in magenta' do
    @str.magenta('').should match(/^\x1b\[#{Magenta}/)
    @str.magenta('').should match(/\x1b\[0m$/)
  end
end
