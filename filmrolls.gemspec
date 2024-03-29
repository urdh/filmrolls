$LOAD_PATH.push File.expand_path('lib', __dir__)
require 'filmrolls/version'

Gem::Specification.new do |s|
  s.name        = 'filmrolls'
  s.version     = Filmrolls::VERSION
  s.summary     = 'Tag TIFF files with EXIF data extracted from XML data'
  s.required_ruby_version = '~> 3.0'

  s.author      = 'Simon Sigurdhsson'
  s.email       = 'Sigurdhsson@gmail.com'
  s.homepage    = 'https://github.com/urdh/filmrolls'
  s.license     = 'ISC'

  s.description = <<-DESCRIPTION
    This is a utility designed to read the XML files used by the Film Rolls
    iOS app, and enable batch EXIF tagging of scanned negatives in TIFF format
    based on the information in these XML files.
  DESCRIPTION

  s.files = %w[
    CHANGELOG.md
    filmrolls.gemspec
    Rakefile
    README.md
    LICENSE.md
    bin/filmrolls
    man/filmrolls.1
    lib/filmrolls.rb
    lib/filmrolls/cli.rb
    lib/filmrolls/exiftool.rb
    lib/filmrolls/metadata.rb
    lib/filmrolls/negative.rb
    lib/filmrolls/version.rb
    lib/filmrolls/xmlformat.rb
    test/test_helper.rb
    test/test_exiftool.rb
    test/test_metadata.rb
    test/test_xmlformat.rb
    test/data/filmrolls.xml
    test/data/with-exif.tiff
    test/data/without-exif.tiff
    test/data/meta-copyright.yaml
    test/data/meta-creative-commons.yaml
    test/data/meta-public-domain.yaml
  ]
  # TODO: how to generate the man page and inclue in the gem?

  s.bindir      = 'bin'
  s.executables = %w[filmrolls]

  s.require_paths = 'lib'
  s.test_files    = %w[test/test_exiftool.rb test/test_metadata.rb test/test_xmlformat.rb]

  s.extra_rdoc_files = %w[README.md LICENSE.md bin/filmrolls]
  s.rdoc_options     = [
    '--line-numbers',
    '--inline-source',
    '--title',
    'Film Rolls EXIF tagger',
    '--main',
    'README.md'
  ]

  s.add_dependency 'commander', ['~> 4.6']
  s.add_dependency 'exiftool_vendored', ['>= 12']
  s.add_dependency 'geokit', ['~> 1.13']
  s.add_dependency 'mini_exiftool', ['~> 2.10']
  s.add_dependency 'nokogiri', ['~> 1.12']
  s.add_dependency 'terminal-table', ['~> 3.0']

  s.add_development_dependency 'bundler', ['~> 2.2']
  s.add_development_dependency 'minitest', ['~> 5.14']
  s.add_development_dependency 'minitest-reporters', ['~> 1.4']
  s.add_development_dependency 'rake', '~> 13.0'
  s.add_development_dependency 'rdoc', ['~> 6.3']
  s.add_development_dependency 'ronn', ['~> 0.7.0']
  s.add_development_dependency 'rubocop', ['~> 1.21']
  s.add_development_dependency 'rubocop-minitest', ['~> 0.15.0']
  s.add_development_dependency 'rubocop-rake', ['~> 0.6.0']
  s.add_development_dependency 'simplecov', ['~> 0.20.0']
end
