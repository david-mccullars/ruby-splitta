require "bundler/gem_tasks"
require "rspec/core/rake_task"

RSpec::Core::RakeTask.new(:spec)

task :default => :spec

require 'rdoc/task'
RDoc::Task.new do |rdoc|
  rdoc.main = "README.md"
  rdoc.rdoc_files.include("README.md", "lib/**/*.rb")
end

def unpickle(file)
  require 'rubypython'

  RubyPython.run do
    cPickle = import 'cPickle'
    gzip = import 'gzip'

    io = gzip.open(file, 'rb')
    data = cPickle.load(io)
    io.close()

    data = data.rubify
    if data.keys.first.is_a?(RubyPython::Tuple)
      data = data.each_with_object({}) do |(k, v), h|
        h[k.to_a] = v
      end
    end

    return data
  end
end

def gzip_dump(file, obj)
  require 'fileutils'
  require 'zlib'

  FileUtils.mkdir_p(File.dirname(file))
  Zlib::GzipWriter.open(file) do |gz|
    gz.write(Marshal.dump(obj))
  end
end

task :unpickle, [:file] do |_t, args|
  files = Dir[args[:file] || 'data/src/**/*'].select do |f|
    File.file?(f)
  end

  files.each do |src|
    puts "Unpickling #{src} ..."
    gzip_dump(src.sub('/src/', '/'), unpickle(src))
  end
end
