lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'splitta/version'

Gem::Specification.new do |spec|
  spec.name          = 'splitta'
  spec.version       = Splitta::VERSION
  spec.authors       = ['David McCullars']
  spec.email         = ['david.mccullars@gmail.com']

  spec.summary       = 'Implementation of Splitta in Ruby'
  spec.description   = 'Implementation of Splitta in Ruby.  See https://code.google.com/archive/p/splitta/'
  spec.homepage      = 'https://github.com/david-mccullars/ruby-splitta'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler'
  spec.add_development_dependency 'rake'
  spec.add_development_dependency 'rspec'
  spec.add_development_dependency 'rubocop'
  spec.add_development_dependency 'rubypython'
  spec.add_development_dependency 'simplecov', '~> 0.17.0' # 0.18 not supported by code climate
end
