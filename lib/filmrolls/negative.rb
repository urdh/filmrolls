require 'filmrolls/exiftool'

module Filmrolls
  class Negative
    def initialize(path)
      @file = Exiftool.new(path)
    end

    def merge(args)
      args.each do |key, value|
        method = "#{key}="
        public_send(method, value) if respond_to? method
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
      @file[:FNumber] = val
    end

    def speed=(val)
      @file[:ISO] = val
      @file[:ISOSpeed] = val
      @file[:SensitivityType] = 'ISO Speed'
    end

    def shutter_speed=(val)
      @file[:ExposureTime] = val
      @file[:ShutterSpeedValue] = val.to_f
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
      model = val.strip[(make.length)..]
      @file[:Lens] = val.strip
      @file[:LensMake] = make.strip
      @file[:LensModel] = model.strip
    end

    def camera=(val)
      make = val.strip.split(/\s+/)[0]
      model = val.strip[(make.length)..]
      @file[:LocalizedCameraModel] = val.strip
      @file[:Make] = make.strip
      @file[:Model] = model.strip
    end

    def author=(val)
      @file[:Artist] = val
      @file['By-Line'] = val
      @file[:Author] = val
      @file[:Creator] = val
      @file['By-lineTitle'] = 'Photographer'
      @file[:AttributionName] = val if @file[:License]
    end

    def copyright=(val)
      year =
        if @file[:datetimeoriginal]
          @file[:datetimeoriginal].year
        else
          @file[:datetimecreated] ? @file[:datetimecreated].year : Time.now.year
        end
      notice = format(val, year => year)
      @file[:Copyright] = notice
      @file[:CopyrightNotice] = notice
      @file[:Rights] = notice
    end

    def author_url=(val)
      @file[:AttributionURL] = val
    end

    def license_url=(val)
      @file[:License] = val
      @file[:AttributionName] = @file[:Artist] if @file[:Artist]
    end

    def marked=(val)
      @file[:Marked] = val
    end

    def usage_terms=(val)
      @file[:UsageTerms] = val
    end
  end
end
