require 'roll2exif/version'
require 'roll2exif/xml'
require 'executable'

module Roll2Exif
  module Utilities
    require 'rainbow'
    def error(message)
      puts Rainbow('Error: ').red + message
      exit 1
    end

    def warning(message)
      puts Rainbow('Warning: ').red + message
    end

    def success(message)
      puts Rainbow(message).green
    end

    def print(message)
      puts message
    end
  end

  class Roll2ExifCli
    include Utilities
    include Executable

    # List film roll IDs in a given XML file.
    class List < self
      def call(*args)
        if args.size != 1
          error "`#{cli.name}` takes exactly one positional argument"
        end

        begin
          input = File.open(args[0], 'r')
        rescue
          error "could not open file `#{args[0]}` for reading"
        end

        Roll2Exif::XML(input)[:rolls].each do |roll|
          print roll.id
        end
      end
    end

    # Show this message.
    def help!
      cli.show_help
      exit
    end

    # Show the version of this application.
    def version!
      puts "roll2exif #{Roll2Exif::VERSION}"
      exit
    end
  end
end
