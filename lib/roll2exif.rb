require 'roll2exif/cli'

module Roll2Exif
  class << self
    def execute(args)
      begin
        Roll2ExifCli.execute(args)
      rescue NoMethodError
        Roll2ExifCli.new.help!
      end
    end
  end
end
