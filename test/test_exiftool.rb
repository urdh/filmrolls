require 'test_helper'
require 'minitest/autorun'
require 'roll2exif/exiftool'

describe Roll2Exif::Exiftool do
  it 'has the correct (vendored) exiftool version' do
    require 'exiftool_vendored/version'
    vendored_version = ExiftoolVendored::VERSION
    executable_version = Gem::Version.new(Roll2Exif::Exiftool.exiftool_version)

    executable_version.must_equal vendored_version
  end

  it 'should be able to load EXIF tags from TIFF files' do
    Roll2Exif::Exiftool.new('test/data/with-exif.tiff')
    Roll2Exif::Exiftool.new('test/data/without-exif.tiff')
  end
end
