require 'filmrolls'
require 'commander'

module Filmrolls
  module Cli
    include Commander::Methods

    def self.run
      program :version,     Filmrolls::VERSION
      program :description, 'Tag TIFF files with EXIF data extracted from XML.'
      program :help_formatter, :compact

      global_option '-r', '--rolls FILE', 'Film Rolls XML file (default: stdin)' do |r|
        $rolls_file = r
      end
      global_option '-m', '--meta FILE', 'Author metadata YAML file' do |r|
        $yaml_file = r
      end

      command 'list-rolls' do |c|
        c.syntax      = 'filmrolls list-rolls [--rolls FILE]'
        c.summary     = 'List film rolls'
        c.description = 'List ID and additional data for all film rolls ' \
                        'in input.'

        c.action do |_args, _options|
          rolls = get_rolls($rolls_file).map do |roll|
            roll.merge(
              frames: roll[:frames].length,
              unload: roll[:unload].to_date,
              load: roll[:load].to_date
            )
          end

          unless rolls.empty?
            require 'terminal-table'
            head = rolls.first.keys.map(&:capitalize)
            rows = rolls.map(&:values)
            say Terminal::Table.new(headings: head, rows: rows)
          end
        end
      end

      command 'list-frames' do |c|
        c.syntax      = 'filmrolls list-frames [--rolls FILE] --id ID'
        c.summary     = 'List frames'
        c.description = 'List frames from film roll with ID in input.'
        c.option '-i', '--id ID',   'Use data from roll with id ID'

        c.action do |_args, options|
          abort "A film roll ID must be supplied" if options.id.nil?

          roll = get_rolls($rolls_file).detect do |r|
            r[:id] == options.id
          end

          abort "Could not find film roll with ID #{options.id}" if roll.nil?

          unless roll.nil?
            require 'terminal-table'
            head = roll[:frames].first.keys.map(&:capitalize)
            rows = roll[:frames].map(&:values)
            say Terminal::Table.new(headings: head, rows: rows)
          end
        end
      end

      command :tag do |c|
        c.syntax      = 'filmrolls tag [--dry-run] [--rolls FILE] --id ID IMAGE...'
        c.summary     = 'Write EXIF tags'
        c.description = 'Write EXIF tags to a set of images using data from ' \
                        'film roll with ID in input.'
        c.option '-i', '--id ID',   'Use data from roll with id ID'
        c.option '-n', '--dry-run', "Don't actually modify any files"

        c.action do |args, options|
          abort "A film roll ID must be supplied" if options.id.nil?

          roll = get_rolls($rolls_file).detect do |r|
            r[:id] == options.id
          end

          abort "Could not find film roll with ID #{options.id}" if roll.nil?

          unless args.length == roll[:frames].length
            abort "Expected #{roll[:frames].length} images, got #{args.length}"
          end

          roll[:frames].zip(args).each do |frame, file|
            log 'Path', file
            negative = Filmrolls::Negative.new(file)
            log 'Date', frame[:date]
            negative.date = frame[:date]
            log 'Camera', roll[:camera]
            negative.camera = roll[:camera]
            log 'Lens', frame[:lens]
            negative.lens = frame[:lens]
            log 'Film', roll[:film]
            negative.film = roll[:film]
            log 'ISO', roll[:speed]
            negative.speed = roll[:speed]
            if frame[:shutter_speed] != 0 and frame[:aperture] != 0
              log 'Shutter speed', "#{frame[:shutter_speed]}s"
              negative.shutter_speed = frame[:shutter_speed]
              log 'Aperture', "ƒ/#{frame[:aperture]}"
              negative.aperture = frame[:aperture]
            end
            if frame[:compensation] != 0
              log 'Compensation', frame[:compensation]
              negative.compensation = frame[:compensation]
            end
            if frame[:position] != Geokit::LatLng.new(0.0, 0.0)
              log 'Position', frame[:position]
              negative.position = frame[:position]
            end
            negative.save! unless options.dry_run
          end
        end
      end

      command 'apply-metadata' do |c|
        c.syntax      = 'filmrolls apply-metadata [--dry-run] --meta FILE IMAGE...'
        c.summary     = 'Write author metadata'
        c.description = 'Write author metadata to a set of images using YAML data from FILE.'
        c.option '-n', '--dry-run', "Don't actually modify any files"

        c.action do |args, options|
          abort "A YAML file must be supplied" if $yaml_file.nil?

          meta = get_metadata($yaml_file)
          meta.each { |k, v| log k.to_s.gsub('_',' ').capitalize, v }

          args.each do |file|
            log 'Path', file
            negative = Filmrolls::Negative.new(file)
            negative.merge(meta)
            negative.save! unless options.dry_run
          end
        end
      end
    end

    class << self
      private

      def get_rolls(file)
        begin
          Filmrolls::XMLFormat.load(file.nil? ? $stdin.read : File.read(file))[:rolls]
        rescue SystemCallError => err
          abort "Could not read input XML: #{err.message}"
        end
      end

      def get_metadata(file)
        begin
          file.nil? ? Hash.new : Filmrolls::Metadata.load(File.read(file))
        rescue SystemCallError => err
          abort "Could not read input YAML: #{err.message}"
        end
      end
    end
  end
end
