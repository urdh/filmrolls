require 'filmrolls'
require 'commander'

module Filmrolls
  module Cli
    include Commander::Methods

    def self.run
      program :version,     Filmrolls::VERSION
      program :description, 'Tag TIFF files with EXIF data extracted from XML.'
      program :help_formatter, :compact

      global_option '-r', '--rolls FILE', 'Film Rolls XML file (default: stdin)'

      command 'list-rolls' do |c|
        c.syntax      = 'filmrolls list-rolls [--rolls FILE]'
        c.summary     = 'List film rolls'
        c.description = 'List ID and additional data for all film rolls ' \
                        'in input.'

        c.action do |_args, options|
          rolls = get_rolls(options.rolls).map do |roll|
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

      command :tag do |c|
        c.syntax = 'filmrolls tag [--dry-run] [--rolls FILE] --id ID IMAGE...'
        c.summary = 'Write EXIF tags'
        c.description = 'Write EXIF tags to a set of images using data from ' \
                        'film roll with ID in input.'
        c.option '-i', '--id ID',   'Use data from roll with id ID'
        c.option '-n', '--dry-run', "Don't actually modify any files"

        c.action do |_args, _options|
          raise NotImplementedError
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
    end
  end
end
