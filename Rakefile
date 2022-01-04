require 'bundler/gem_tasks'
require 'rspec/core/rake_task'

RSpec::Core::RakeTask.new(:spec)

task default: :spec

require 'rdoc/task'
RDoc::Task.new do |rdoc|
  rdoc.main = 'README.md'
  rdoc.rdoc_files.include('README.md', 'lib/**/*.rb')
end

def unpickle(file)
  out, status = Open3.capture2e("bin/pickle2json #{file.inspect}")
  abort out unless status.success?
  JSON.parse(out).to_h
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
  require 'json'
  require 'open3'

  files = Dir[args[:file] || 'data/src/**/*'].select do |f|
    File.file?(f)
  end

  files.map do |src|
    fork do
      puts "Unpickling #{src} ..."
      gzip_dump(src.sub('/src/', '/'), unpickle(src))
    end
  end.map do |pid|
    Process.wait2(pid).last
  end.all?(&:success?) or exit(1)
end
