require 'exiftool_vendored'
require 'mini_exiftool'

module Roll2Exif
  class Exiftool < MiniExiftool
    self.command = ExiftoolVendored.path_to_exiftool

    def initialize(filename_or_io = nil, opts = {})
      opts[:timestamps] = DateTime unless opts.key? :timestamps
      super(filename_or_io, opts)
    end
  end
end
