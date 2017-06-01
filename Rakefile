require 'rake/testtask'

task :man do
  require 'rubygems'
  spec = Gem::Specification.load('filmrolls.gemspec')

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

Rake::TestTask.new do |t|
  t.libs << 'test'
  t.test_files = FileList[
    'test/test_exiftool.rb',
    'test/test_xmlformat.rb'
  ]
end

task default: %w[test]
