require 'rake/testtask'
require 'rdoc/task'
require 'rubygems/package_task'

def gemspec
  require 'rubygems/specification'
  @gemspec ||= Gem::Specification.load(
    File.expand_path(File.dirname(__FILE__) + '/filmrolls.gemspec')
  )
end

rule(/\.[0-9]$/ => [proc { |name| "#{name}.ronn" }]) do |task|
  require 'ronn'
  appname, section = File.basename(task.name).split('.')
  File.open(task.name, 'w') do |man|
    man.write Ronn.new(
      task.source,
      name: appname,
      section: section,
      tagline: gemspec.summary,
      manual: "#{gemspec.name} v#{gemspec.version}"
    ).to_roff
  end
end

desc 'Build all manual pages'
task ronn: gemspec.files.select { |f| f[/\.[0-9]$/] } {}

Gem::PackageTask.new(gemspec) {}

RDoc::Task.new(:rdoc) do |r|
  r.options = gemspec.rdoc_options
  r.rdoc_files.include(gemspec.require_paths)
  r.rdoc_files.include(gemspec.extra_rdoc_files)
end

Rake::TestTask.new(:test) do |t|
  t.libs       = gemspec.require_paths + %w[test]
  t.test_files = gemspec.test_files
end

task default: :test
