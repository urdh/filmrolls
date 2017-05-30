require 'nokogiri'
require 'date'
require 'geokit'

module Roll2Exif
  class Frame
    attr_accessor :lens, :aperture, :shutter_speed, :compensation,
                  :accessory, :date, :note, :position

    def initialize(params)
      if params.is_a? Nokogiri::XML::Node
        self.lens = params.at_xpath("./*[local-name()='lens']").text
        self.aperture =
          params.at_xpath("./*[local-name()='aperture']").text.to_f
        self.shutter_speed =
          params.at_xpath("./*[local-name()='shutterSpeed']").text.to_r
        self.compensation =
          params.at_xpath("./*[local-name()='compensation']").text.to_f
        self.accessory = params.at_xpath("./*[local-name()='accessory']").text
        self.date =
          DateTime.iso8601(params.at_xpath("./*[local-name()='date']").text)
        self.note = params.at_xpath("./*[local-name()='note']").text
        self.position = Geokit::LatLng.new(
          params.at_xpath("./*[local-name()='latitude']").text.to_f,
          params.at_xpath("./*[local-name()='longitude']").text.to_f
        )
      else
        params.each { |key, value| public_send "#{key}=", value }
      end
    end
  end

  class Roll
    attr_accessor :id, :film, :speed, :camera, :load, :unload, :frames

    def initialize(params)
      if params.is_a? Nokogiri::XML::Node
        self.id = params.at_xpath("./*[local-name()='note']").text
        self.film = params.at_xpath("./*[local-name()='title']").text
        self.speed = params.at_xpath("./*[local-name()='speed']").text.to_i
        self.camera = params.at_xpath("./*[local-name()='camera']").text
        self.load =
          DateTime.iso8601(params.at_xpath("./*[local-name()='load']").text)
        self.unload =
          DateTime.iso8601(params.at_xpath("./*[local-name()='unload']").text)
        self.frames =
          params.xpath(
            "./*[local-name()='frames']/*[local-name()='frame']"
          ).map { |frame| Frame.new(frame) }
      else
        params.each { |key, value| public_send "#{key}=", value }
      end
    end
  end

  class << self
    def XML(text)
      doc = Nokogiri::XML(text)
      {
        cameras: doc.xpath(
          '/ns:data/ns:cameras/ns:camera',
          'ns' => 'http://www.w3schools.com'
        ).map(&:text),
        lenses: doc.xpath(
          '/ns:data/ns:lenses/ns:lens',
          'ns' => 'http://www.w3schools.com'
        ).map(&:text),
        accessories: doc.xpath(
          '/ns:data/ns:accessories/ns:accessory',
          'ns' => 'http://www.w3schools.com'
        ).map(&:text),
        rolls: doc.xpath(
          '/ns:data/ns:filmRolls/ns:filmRoll',
          'ns' => 'http://www.w3schools.com'
        ).map { |roll| Roll.new(roll) }
      }
    end
  end
end
