#
# A Document points to a collection of Frags
#
module Splitta
  class Doc

    FRAG_SPLITTER = /
      (
        [.!?]         # sentence end punctuation
        (?:
          (?:<.*>)    # extra tag
          |
          [”"')\]}]   # right-handed punctuation to retain
        )*
        \s+           # must have whitespace
      )
    /ux

    SEGMENT_THRESHOLD = 0.5

    attr_reader :frags

    def initialize(text, model:)
      @frags = []
      text.split(FRAG_SPLITTER).each_slice(2) do |frag_text|
        frag = Frag.new(frag_text.join, previous_frag: @frags.last)
        @frags << frag
      end
      model.classify(self)
    end

    #
    # output all the text, split according to predictions
    #
    def segments
      Enumerator.new do |y|
        io = StringIO.new
        frags.each do |frag|
          io << frag.orig
          if frag.over?(SEGMENT_THRESHOLD)
            y << io.string
            io.string = ''
          end
        end
        y << io.string unless io.string.empty?
      end
    end

  end
end
