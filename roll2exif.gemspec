require('rake')

Gem::Specification.new do |s|
  s.name        = 'roll2exif'

  s.version     = '0.0.0'
  s.version     = "#{s.version}-alpha+#{ENV['TRAVIS_COMMIT']}" if ENV['TRAVIS']

  s.summary     = 'Tag TIFF files with EXIF data extracted from XML data'
  s.description = <<-EOF
    This is a utility designed to read the XML files used by the Film Rolls
    iOS app, and enable batch EXIF tagging of scanned negatives in TIFF format
    based on the information in these XML files.
  EOF
  s.author      = 'Simon Sigurdhsson'
  s.email       = 'Sigurdhsson@gmail.com'
  s.homepage    = 'https://github.com/urdh/roll2exif'
  s.license     = 'ISC'

  s.files       = FileList['lib/**', 'bin/*', '*.md', 'test/*'].to_a
  s.bindir      = 'bin'
  s.executables = 'roll2exif'

  s.add_dependency('exiftool', ['~> 1.1'])
  s.add_dependency('exiftool_vendored', ['~> 10.49'])

  s.add_development_dependency('rake', ['~> 12'])
  s.add_development_dependency('bundler', ['~> 1.14'])
  s.add_development_dependency('codacy-coverage', ['~> 1.1'])
end
