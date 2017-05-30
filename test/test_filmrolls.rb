require 'test_helper'
require 'minitest/autorun'
require 'roll2exif/filmrolls'

describe Roll2Exif do
  let(:data) do
    Roll2Exif::FilmRolls.load(
      <<-EOF
        <?xml version="1.0" encoding="UTF-8"?>
        <data xmlns="http://www.w3schools.com"
              xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
              xsi:schemaLocation="http://www.w3schools.com export.xsd">
          <cameras>
            <camera>Yashica Electro 35 GT</camera>
            <camera>Voigtländer Bessa R2M</camera>
          </cameras>
          <lenses>
            <lens>Yashinon 45mm f/1.7</lens>
            <lens>Color Skopar 35/2.5 Pancake II</lens>
          </lenses>
          <accessories>
          </accessories>
          <filmRolls>
          </filmRolls>
        </data>
      EOF
    )
  end

  describe 'after deserialization from XML' do
    it 'should have the expected cameras' do
      data[:cameras].must_include 'Yashica Electro 35 GT'
      data[:cameras].must_include 'Voigtländer Bessa R2M'
    end
    it 'should have the expected lenses' do
      data[:lenses].must_include 'Yashinon 45mm f/1.7'
      data[:lenses].must_include 'Color Skopar 35/2.5 Pancake II'
    end
    it 'should have the expected accessories' do
      data[:accessories].must_be_empty
    end
    it 'should have the expected film rolls' do
      data[:rolls].must_be_empty
    end
  end
end

describe Roll2Exif do
  let(:roll) do
    Roll2Exif::FilmRolls::Parser.load_filmroll(
      Nokogiri::XML.fragment(
        <<-EOF
          <filmRoll>
            <title>Ilford Delta 100</title>
            <speed>100</speed>
            <camera>Voigtländer Bessa R2M</camera>
            <load>2016-03-28T15:16:36Z</load>
            <unload>2016-05-21T14:13:15Z</unload>
            <note>A0012</note>
            <frames></frames>
          </filmRoll>
        EOF
      ).at_xpath('./filmRoll')
    )
  end

  describe 'after deserialization from XML' do
    it 'should have the expected roll id' do
      roll[:id].must_equal 'A0012'
    end
    it 'should have the expected film type' do
      roll[:film].must_equal 'Ilford Delta 100'
    end
    it 'should have the expected film speed' do
      roll[:speed].must_equal 100
    end
    it 'should have the expected camera type' do
      roll[:camera].must_equal 'Voigtländer Bessa R2M'
    end
    it 'should have the expected load date' do
      roll[:load].must_equal DateTime.new(2016, 3, 28, 15, 16, 36, '+00:00')
    end
    it 'should have the expected unload date' do
      roll[:unload].must_equal DateTime.new(2016, 5, 21, 14, 13, 15, '+00:00')
    end
  end
end

describe Roll2Exif do
  let(:frame) do
    Roll2Exif::FilmRolls::Parser.load_frame(
      Nokogiri::XML.fragment(
        <<-EOF
          <frame>
            <lens>Color Skopar 35/2.5 Pancake II</lens>
            <aperture>5.6</aperture>
            <shutterSpeed>1/500</shutterSpeed>
            <compensation></compensation>
            <accessory></accessory>
            <number>1</number>
            <date>2016-05-13T14:12:40Z</date>
            <latitude>57.700767</latitude>
            <longitude>11.953715</longitude>
            <note></note>
          </frame>
        EOF
      ).at_xpath('./frame')
    )
  end

  describe 'after deserialization from XML' do
    it 'should have the expected lens type' do
      frame[:lens].must_equal 'Color Skopar 35/2.5 Pancake II'
    end
    it 'should have the expected aperture' do
      frame[:aperture].must_equal 5.6
    end
    it 'should have the expected shutter speed' do
      frame[:shutter_speed].must_equal Rational(1, 500)
    end
    it 'should have the expected compensation' do
      frame[:compensation].must_equal 0.0
    end
    it 'should have the expected accessory type' do
      frame[:accessory].must_equal ''
    end
    it 'should have the expected date' do
      frame[:date].must_equal DateTime.new(2016, 5, 13, 14, 12, 40, '+00:00')
    end
    it 'should have the expected note' do
      frame[:note].must_equal ''
    end
    it 'should have the expected position' do
      frame[:position].must_equal Geokit::LatLng.new(57.700767, 11.953715)
    end
  end
end
