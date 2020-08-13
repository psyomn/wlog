require 'wlog/tech/uncolored_string'

include Wlog

describe UncoloredString do
  ucs = UncoloredString

  it 'should not color anything' do
    expect(ucs.red('a')).to eq('a')
    expect(ucs.yellow('a')).to eq('a')
    expect(ucs.magenta('a')).to eq('a')
    expect(ucs.green('a')).to eq('a')
    expect(ucs.blue('a')).to eq('a')
    expect(ucs.white('a')).to eq('a')
    expect(ucs.black('a')).to eq('a')
    expect(ucs.cyan('a')).to eq('a')
  end
end
