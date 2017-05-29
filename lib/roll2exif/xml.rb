require 'nokogiri'
require 'roll2exif/roll'

module Roll2Exif
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
