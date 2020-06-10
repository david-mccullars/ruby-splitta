require 'spec_helper'

describe Splitta do
  let(:samples) { File.readlines(File.expand_path('samples.txt', __dir__)).map(&:chomp) }

  it 'detects sentence boundaries with minimal error' do
    expect(Splitta.sentences(samples.join(' ')).to_a).to eq(samples)
  end
end
