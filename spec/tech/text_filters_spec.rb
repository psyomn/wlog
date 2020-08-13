require 'wlog/tech/text_filters'
require 'wlog/tech/ansi_colors'
require 'wlog/tech/wlog_string'

include Wlog
include TextFilters
include AnsiColors

describe TextFilters do
  before :each do
    allow(SysConfig).to receive(:string_decorator).and_return(WlogString)
  end

  it 'should detect a simple link' do
    a = highlight_hyperlink_s('www.google.com')
    b = highlight_hyperlink_s('http://www.google.com')
    c = highlight_hyperlink_s('https://www.google.com')
    expect(a).to match(/^\x1b\[#{Blue}/)
    expect(b).to match(/^\x1b\[#{Blue}/)
    expect(c).to match(/^\x1b\[#{Blue}/)
  end

  it 'should not color a common string' do
    a = highlight_hyperlink_s('potato potato how is the potato')
    expect(a).to eq('potato potato how is the potato')
  end

  it 'should color only links within a mixed string' do
    a = 'http://a.com potato https://go.go cat www.nooo.no yes'
    ret = highlight_hyperlink_s(a)
    count = 0
    ret_a = ret.split
    ret_a.each do |n|
      count += 1 if n.include?("\x1b[#{Blue}")
    end
    # we dected three links
    expect(count).to eq(3)
    # out of 6 tokens
    expect(ret_a.count).to eq(6)
  end

  it 'should preserve line formatting' do
    str = 'this is my line and there is more to say'
    str.concat($/).concat('and there is yet more again').concat($/)
    str.concat('but now I am talking about www.link.com and').concat($/)
    str.concat('will continue to babble on to make sure that the test').concat($/)
    str.concat('is actually quite ok. also www.potato.com!').concat($/)

    res = highlight_hyperlink_s(str)
    expect(res.lines.count).to eq(str.lines.count)
  end
end
