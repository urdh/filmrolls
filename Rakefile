require 'rake/testtask'
require 'rdoc/task'

def gemspec
  require 'rubygems'
  @gemspec ||= Gem::Specification.load(
    File.expand_path(File.dirname(__FILE__) + '/filmrolls.gemspec')
  )
end

  require 'ronn'
  man = Ronn.new(
    'man/filmrolls.1.ronn',
    name: 'filmrolls',
    section: '1',
    tagline: spec.summary,
    manual: "Film Rolls EXIF tagger v#{spec.version}"
  )
  File.open('man/filmrolls.1', 'w') { |f| f.write man.to_roff }
end

RDoc::Task.new(:rdoc) do |r|
  r.options = gemspec.rdoc_options
  r.rdoc_files.include(gemspec.require_paths)
  r.rdoc_files.include(gemspec.extra_rdoc_files)
end

Rake::TestTask.new do |t|
  t.libs << 'test'
  t.test_files = FileList[
    'test/test_exiftool.rb',
    'test/test_xmlformat.rb'
  ]
end

task default: %w[test]
