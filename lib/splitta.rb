require 'singleton'
require 'zlib'

##
# Provides convenience methods for splitting text into sentences.
#
# @see README
##
module Splitta

  autoload :Doc,              'splitta/doc'
  autoload :Frag,             'splitta/frag'
  autoload :Model,            'splitta/model'
  autoload :VERSION,          'splitta/version'
  autoload :WordTokenizer,    'splitta/word_tokenizer'

  def self.sentences(text)
    Doc.new(text, model: Model.instance).segments.map(&:strip)
  end

end
