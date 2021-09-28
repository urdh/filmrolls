require 'test_helper'
require 'minitest/autorun'
require 'filmrolls/exiftool'

describe Filmrolls::Exiftool do
  it 'has the correct (vendored) exiftool version' do
    require 'exiftool_vendored/version'
    vendored_version = ExiftoolVendored::VERSION
    executable_version = Gem::Version.new(Filmrolls::Exiftool.exiftool_version)

    _(executable_version).must_equal vendored_version
  end

  it 'should be able to load EXIF tags from TIFF files' do
    Filmrolls::Exiftool.new('test/data/with-exif.tiff')
    Filmrolls::Exiftool.new('test/data/without-exif.tiff')
  end
end
