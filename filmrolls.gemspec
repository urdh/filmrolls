$LOAD_PATH.push File.expand_path('../lib', __FILE__)
require 'filmrolls/version'
require 'rake'

Gem::Specification.new do |s|
  s.name        = 'filmrolls'
  s.version     = Filmrolls::VERSION
  s.summary     = 'Tag TIFF files with EXIF data extracted from XML data'

  s.author      = 'Simon Sigurdhsson'
  s.email       = 'Sigurdhsson@gmail.com'
  s.homepage    = 'https://github.com/urdh/filmrolls'
  s.license     = 'ISC'

  s.description = <<-EOF
    This is a utility designed to read the XML files used by the Film Rolls
    iOS app, and enable batch EXIF tagging of scanned negatives in TIFF format
    based on the information in these XML files.
  EOF

  s.files       = FileList['lib/**', 'bin/*', '*.md', 'test/*'].to_a
  s.bindir      = 'bin'
  s.executables = 'filmrolls'

  s.add_dependency 'mini_exiftool', ['~> 2.8']
  s.add_dependency 'exiftool_vendored', ['~> 10.49']
  s.add_dependency 'nokogiri', ['~> 1.7']
  s.add_dependency 'geokit', ['~> 1.11']
  s.add_dependency 'commander', ['~> 4.4']
  s.add_dependency 'terminal-table', ['~> 1.8']

  s.add_development_dependency 'rake', ['~> 12']
  s.add_development_dependency 'bundler', ['~> 1.14']
  s.add_development_dependency 'codacy-coverage', ['~> 1.1']
  s.add_development_dependency 'minitest', ['~> 5.8']
  s.add_development_dependency 'minitest-reporters', ['~> 1.1']
end
