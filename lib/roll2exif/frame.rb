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
end
