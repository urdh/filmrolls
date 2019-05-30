require 'filmrolls/exiftool'

module Filmrolls
  class Negative
    def initialize(path)
      @file = Exiftool.new(path)
    end

    def merge(*args)
      args.each do |key, value|
        method = "#{key}="
        @self.public_send(method, value) if @self.respond_to? method
      end
    end

    def to_s
      require 'yaml'
      @file.to_yaml
    end

    def changed?
      @file.changed?
    end

    def save!
      @file.save!
    end

    def aperture=(val)
      @file[:ApertureValue] = val
    end

    def speed=(val)
      @file[:ISO] = val
    end

    def shutter_speed=(val)
      @file[:ExposureTime] = val
    end

    def compensation=(val)
      @file[:ExposureCompensation] = val
    end

    def position=(val)
      @file[:GPSLatitude] = "#{val.lat} degrees"
      @file[:GPSLatitudeRef] = 'North'
      @file[:GPSLongitude] = "#{val.lng} degrees"
      @file[:GPSLongitudeRef] = 'East'
    end

    def film=(val)
      @file[:UserComment] = val
    end

    def date=(val)
      @file[:DateTimeOriginal] = val
    end

    def lens=(val)
      # TODO: this is hacky as f
      make = val.strip.split(/\s+/)[0]
      model = val.strip[(make.length)..-1]
      @file[:Lens] = val.strip
      @file[:LensMake] = make.strip
      @file[:LensModel] = model.strip
    end

    def camera=(val)
      make = val.strip.split(/\s+/)[0]
      model = val.strip[(make.length)..-1]
      @file[:LocalizedCameraModel] = val.strip
      @file[:Make] = make.strip
      @file[:Model] = model.strip
    end
  end
end
