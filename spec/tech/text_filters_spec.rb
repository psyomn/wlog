require 'wlog/tech/text_filters'
require 'wlog/tech/ansi_colors'

include Wlog
include TextFilters
include AnsiColors

describe TextFilters do 

  before :all do 
    SysConfig.ansi!
  end

  it 'should detect a simple link' do
    a = highlight_hyperlink_s("www.google.com")
    b = highlight_hyperlink_s("http://www.google.com")
    c = highlight_hyperlink_s("https://www.google.com")
    expect(a).to match(/^\x1b\[#{Blue}/)
    expect(b).to match(/^\x1b\[#{Blue}/)
    expect(c).to match(/^\x1b\[#{Blue}/)
  end
  
  it 'should not color a common string' do 
    a = highlight_hyperlink_s("potato potato how is the potato")
    expect(a).to eq("potato potato how is the potato")
  end

  it 'should color only links within a mixed string' do
    a = "http://a.com potato https://go.go cat www.nooo.no yes"
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

end
