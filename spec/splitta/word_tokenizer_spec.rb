require 'spec_helper'

describe Splitta::WordTokenizer do
  subject { Class.new { include Splitta::WordTokenizer }.new }

  def expect_tokenize(mapping)
    mapping.each do |input, output|
      expect(subject.tokenize(input)).to eq(output)
    end
  end

  specify 'uniform quotes' do
    expect_tokenize %(''Abraham♥'', ``Betty``, and “Cane”) => %(" Abraham♥ " , " Betty " , and " Cane ")
  end

  specify 'Separate punctuation (except period) from words' do
    expect_tokenize %['w(x)&♥[y]!] => %[' w ( x ) & ♥ [ y ] !],
                    %[)s] => %[) s],
                    %(s{) => %(s {),
                    %(-s1 -s2 --s3) => %(- s1 - s2 -- s3)
  end

  specify 'Treat double-hyphen as one token' do
    expect_tokenize %(----a b--------c----d e--f g----) => %(----a b -------- c----d e -- f g----)
  end

  specify 'Only separate comma if space follows' do
    expect_tokenize %(,a b,c d, ,e f , g h,) => %(, a b,c d , , e f , g h ,)
  end

  specify 'Combine dots separated by whitespace to be a single token' do
    expect_tokenize %(a . . . b . . . . . . . . c) => %(a ... b ... ... . . c)
  end

  specify 'Separate "No.6"' do
    expect_tokenize %(C.4 x.22 ♥.9 3.3) => %(C. 4 x. 22 ♥.9 3.3)
  end

  specify 'Separate words from ellipses' do
    expect_tokenize %(a...b c.......d ..e f..) => %(a ... b c ....... d .. e f .. )
  end

  specify 'fix %, $, &' do
    expect_tokenize %(33% x%d 2%) => %(33 % x%d 2 %)
    expect_tokenize %($44 $.35 $s) => %($ 44 $ .35 $s)
    expect_tokenize %(r&d x & y w& z a &b) => %(r&d x & y w& z a & b)
    expect_tokenize %(bob&jill fr;s&en;t) => %(bob & jill fr ; s&en ; t)
  end

  specify "fix (n 't) --> ( n't)" do
    expect_tokenize %(can't can 't can 't) => %(ca n't can ' t can ' t)
    expect_tokenize %(CAN'T CAN 'T CAN 'T) => %(CA N'T CAN ' T CAN ' T)
  end

  specify 'treebank tokenizer special words' do
    expect_tokenize %(cannot Cannot CANNOT) => %(can not Can not CANNOT)
  end

  specify 'collapse spaces' do
    expect_tokenize %(a     b    ♥) => %(a b ♥)
  end
end
