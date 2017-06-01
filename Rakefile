require 'rake/testtask'
require 'rdoc/task'

def gemspec
  require 'rubygems'
  @gemspec ||= Gem::Specification.load(
    File.expand_path(File.dirname(__FILE__) + '/filmrolls.gemspec')
  )
end

task :ronn do
  require 'ronn'
  gemspec.files.select { |p| p[/\.[0-9]$/] }.each do |manpage|
    appname, section = File.basename(manpage).split('.')
    next unless File.exist?("#{manpage}.ronn")
    File.open(manpage, 'w') do |man|
      man.write Ronn.new(
        "#{manpage}.ronn",
        name: appname,
        section: section,
        tagline: gemspec.summary,
        manual: "#{gemspec.name} v#{gemspec.version}"
      ).to_roff
    end
  end
end

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
