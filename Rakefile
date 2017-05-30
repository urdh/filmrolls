require 'rake/testtask'

Rake::TestTask.new do |t|
  t.libs << 'test'
  t.test_files = FileList[
    'test/test_exiftool.rb',
    'test/test_xmlformat.rb'
  ]
end

task default: %w[test]
