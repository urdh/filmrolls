require 'exiftool_vendored'
require 'mini_exiftool'

module Filmrolls
  class Exiftool < MiniExiftool
    self.command = ExiftoolVendored.path_to_exiftool

    def initialize(filename_or_io = nil, opts = {})
      opts[:timestamps] = DateTime unless opts.key? :timestamps
      opts[:coord_format] = '%.6f degrees' unless opts.key? :coord_format
      super(filename_or_io, opts)
    end
  end
end
