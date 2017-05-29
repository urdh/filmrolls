require 'nokogiri'
require 'date'
require 'roll2exif/frame'

module Roll2Exif
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
end
