#
# A fragment of text that ends with a possible sentence boundary
#
module Splitta
  class Frag

    include WordTokenizer

    attr_reader :orig, :last_word, :next_word
    attr_accessor :pred

    def initialize(orig, previous_frag: nil)
      words = clean(orig).split
      previous_frag.next_word = words.first if previous_frag
      @orig = orig
      @last_word = words.last
    end

    # ... w1. (sb?) w2 ...
    # Features, listed roughly in order of importance:
    #
    # (1) w1: word that includes a period
    # (2) w2: the next word, if it exists
    # (3) w1length: number of alphabetic characters in w1
    # (4) w2cap: true if w2 is capitalized
    # (5) both: w1 and w2
    # (6) w1abbr: log count of w1 in training without a final period
    # (7) w2lower: log count of w2 in training as lowercased
    # (8) w1w2upper: w1 and w2 is capitalized
    def features(model)
      Enumerator.new do |y|
        y << [:w1, w1]
        y << [:w2, w2]
        y << [:both, w1, w2]

        if alphabetic?(w1)
          y << [:w1length, w1length]
          y << [:w1abbr, w1abbr(model)]
        end

        if alphabetic?(w2)
          y << [:w2cap, w2cap]
          y << [:w2lower, w2lower(model)]
          y << [:w1w2upper, w1, w2cap]
        end
      end
    end

    def over?(threshold)
      !!pred && pred > threshold
    end

    protected

    attr_writer :next_word

    private

    # normalize numbers, discard some punctuation that can be ambiguous
    def clean(text)
      text = tokenize(text)
      text.gsub!(/[.,\d]*\d/, '<NUM>')
      text.gsub!(%r{[^a-zA-Z0-9,.;:<>\-'/?!$% ]}, '')
      text.gsub!('--', ' ')
      text
    end

    def w1
      @w1 ||= last_word&.sub(/(^.+?-)/, '')
    end

    def w2
      @w2 ||= next_word&.sub(/(-.+?)$/, '')
    end

    def w1length
      [10, w1.sub(/\W/, '').length].min
    end

    def w1abbr(model)
      Math.log(1 + model.non_abbrs.fetch(w1.chop, 0.0)).to_i
    end

    def w2cap
      upcase?(w2.chars.first) ? 'True' : 'False'
    end

    def w2lower(model)
      Math.log(1 + model.lower_words.fetch(w2.downcase, 0.0)).to_i
    end

    def alphabetic?(str)
      !!/[a-zA-Z. ]+/u.match(str)
    end

    def upcase?(str)
      str.upcase == str
    end

  end
end
