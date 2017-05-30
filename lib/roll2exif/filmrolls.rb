require 'nokogiri'
require 'date'
require 'geokit'

module Roll2Exif
  module FilmRolls
    class Parser
      def self.load(io)
          doc = Nokogiri::XML(io)
          doc.remove_namespaces!
          {
            cameras:
              doc.xpath('/data/cameras/camera').map { |n| load_camera(n) },
            lenses:
              doc.xpath('/data/lenses/lens').map { |n| load_lens(n) },
            accessories:
              doc.xpath('/data/accessories/accessory').map { |n| load_accessory(n) },
            rolls:
              doc.xpath('/data/filmRolls/filmRoll').map { |n| load_filmroll(n) }
          }
      end

      class << self
        private

        def load_camera(node)
          node.text
        end

        def load_lens(node)
          node.text
        end

        def load_accessory(node)
          node.text
        end

        public # TODO
        def load_filmroll(node)
          {
            id: node.at_xpath('./note').text,
            film: node.at_xpath('./title').text,
            speed: node.at_xpath('./speed').text.to_i,
            camera: node.at_xpath('./camera').text,
            load: DateTime.iso8601(node.at_xpath('./load').text),
            unload: DateTime.iso8601(node.at_xpath('./unload').text),
            frames: node.xpath('./frames/frame').map { |n| load_frame(n) }
          }
        end

        public # TODO
        def load_frame(node)
          {
            lens: node.at_xpath('./lens').text,
            aperture: node.at_xpath('./aperture').text.to_f,
            shutter_speed: node.at_xpath('./shutterSpeed').text.to_r,
            compensation: node.at_xpath('./compensation').text.to_f,
            accessory: node.at_xpath('./accessory').text,
            date: DateTime.iso8601(node.at_xpath('./date').text),
            note: node.at_xpath('./note').text,
            position: Geokit::LatLng.new(
              node.at_xpath('./latitude').text.to_f,
              node.at_xpath('./longitude').text.to_f
            )
          }
        end
      end
    end

    def self.load(io)
      Parser.load(io)
    end
  end
end
