#
# A list of (regexp, repl) pairs applied in sequence.
# The resulting string is split on whitespace.
# (Adapted from the Punkt Word Tokenizer)
#
module Splitta
  module WordTokenizer

    TOKENIZE_REGEXPS = [
      # uniform quotes
      /
        '' |
        `` |
        “  |
        ”
      /ux,                          '"',

      # Separate punctuation (except period) from words:
      /(^|\s)(')/,                  '\1\2 ',
      /(?<=[("`{\[:;&#*@])(.)/,     ' \1',    # left-hand punctuation
      /(.)(?=[?!)";}\]*:@'])/,      '\1 ',    # right-hand punctuation
      /(?<=[)}\]])(.)/,             ' \1',    # left-hand close paren
      /(.)(?=[({\[])/,              '\1 ',    # right-hand open paren
      /((^|\s)-)(?=[^-])/,          '\1 ',    # starting hyphen/minus

      # Treat double-hyphen as one token:
      /([^-])(--+)([^-])/,          '\1 \2 \3',

      # Only separate comma if space follows:
      /(\s|^)(,)(?=(\S))/u,         '\1\2 ',
      /(.)(,)(\s|$)/u,              '\1 \2\3',

      # Combine dots separated by whitespace to be a single token:
      /\.\s\.\s\./u,                '...',

      # Separate "No.6"
      /([A-Za-z]\.)(\d+)/,          '\1 \2',

      # Separate words from ellipses
      /([^.]|^)(\.{2,})(.?)/,       '\1 \2 \3',
      /(^|\s)(\.{2,})([^.\s])/u,    '\1\2 \3',
      /(^|\s)(\.{2,})([^.\s])/u,    '\1 \2\3',

      # fix %, $, &
      /(\d)%/,                      '\1 %',
      /\$(\.?\d)/,                  '$ \1',
      /(\w)& (\w)/,                 '\1&\2',
      /(\w\w+)&(\w\w+)/,            '\1 & \2',

      # fix (n 't) --> ( n't)
      /n 't( |$)/,                  ' n\'t\1',
      /N 'T( |$)/,                  ' N\'T\1',

      # treebank tokenizer special words
      /([Cc])annot/,                '\1an not',
      /\s+/,                        ' ',
    ]

    #
    # Tokenize a string using the rules above
    #
    def tokenize(text)
      text = text.dup
      TOKENIZE_REGEXPS.each_slice(2) do |regexp, repl|
        text.gsub!(regexp, repl)
      end
      text
    end

  end
end
