require 'wlog/tech/wlog_string'
require 'wlog/tech/ansi_colors'

include Wlog
include AnsiColors

describe WlogString do
  before(:all) do
    @str = WlogString
  end

  it 'should write in red' do
    expect(@str.red('')).to match(/^\x1b\[#{Red}/)
    expect(@str.red('')).to match(/\x1b\[0m$/)
  end

  it 'should write in green' do
    expect(@str.green('')).to match(/^\x1b\[#{Green}/)
    expect(@str.green('')).to match(/\x1b\[0m$/)
  end

  it 'should write in blue' do
    expect(@str.blue('')).to match(/^\x1b\[#{Blue}/)
    expect(@str.blue('')).to match(/\x1b\[0m$/)
  end

  it 'should write in yellow' do
    expect(@str.yellow('')).to match(/^\x1b\[#{Yellow}/)
    expect(@str.yellow('')).to match(/\x1b\[0m$/)
  end

  it 'should write in white' do
    expect(@str.white('')).to match(/^\x1b\[#{White}/)
    expect(@str.white('')).to match(/\x1b\[0m$/)
  end

  it 'should write in cyan' do
    expect(@str.cyan('')).to match(/^\x1b\[#{Cyan}/)
    expect(@str.cyan('')).to match(/\x1b\[0m$/)
  end

  it 'should write in magenta' do
    expect(@str.magenta('')).to match(/^\x1b\[#{Magenta}/)
    expect(@str.magenta('')).to match(/\x1b\[0m$/)
  end
end
