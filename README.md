# Ruby Splitta

* README:         https://github.com/david-mccullars/ruby-splitta
* Documentation:  http://www.rubydoc.info/github/david-mccullars/ruby-splitta
* Bug Reports:    https://github.com/david-mccullars/ruby-splitta/issues


## Status

[![Gem Version](https://badge.fury.io/rb/splitta.svg)](https://badge.fury.io/rb/splitta)
[![Travis Build Status](https://travis-ci.org/david-mccullars/ruby-splitta.svg?branch=master)](https://travis-ci.org/david-mccullars/ruby-splitta)
[![Code Climate](https://codeclimate.com/github/david-mccullars/ruby-splitta/badges/gpa.svg)](https://codeclimate.com/github/david-mccullars/ruby-splitta)
[![Test Coverage](https://codeclimate.com/github/david-mccullars/ruby-splitta/badges/coverage.svg)](https://codeclimate.com/github/david-mccullars/ruby-splitta/coverage)

## Description

[Splitta](https://code.google.com/archive/p/splitta/) Includes proper
tokenization and models for very high accuracy sentence boundary detection
(English only for now). The models are trained from Wall Street Journal news
combined with the Brown Corpus which is intended to be widely representative of
written English. Error rates on test news data are near 0.25%.

## Installation

```
gem install splitta
```

## Requirements

* Ruby 2.5.1 or higher

## Usage

```ruby
require 'splitta'

Splitta.sentences("Some text goes here.")
```

## License

MIT. See the `LICENSE` file.

## References

> Dan Gillick, “Sentence Boundary Detection and the Problem with the U.S.” at NAACL 2009, http://dgillick.com/resource/sbd_naacl_2009.pdf
