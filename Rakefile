require 'rake/testtask'

Rake::TestTask.new do |t|
  t.libs << 'test'
  t.test_files = FileList[
    'test/test_filmrolls.rb',
    'test/test_exiftool.rb'
  ]
end

task default: %w[test]
