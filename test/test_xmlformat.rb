require 'test_helper'
require 'minitest/autorun'
require 'filmrolls/xmlformat'

describe 'Filmrolls::XMLFormat.load' do
  let(:data) do
    @output ||= Filmrolls::XMLFormat.load(File.read('test/data/filmrolls.xml'))
  end

  describe 'the parser output' do
    it 'should contain two cameras' do
      _(data[:cameras]).must_include 'Yashica Electro 35 GT'
      _(data[:cameras]).must_include 'Voigtländer Bessa R2M'
    end

    it 'should contain two lenses' do
      _(data[:lenses]).must_include 'Yashinon 45mm f/1.7'
      _(data[:lenses]).must_include 'Color Skopar 35/2.5 Pancake II'
    end

    it 'should contain zero accessories' do
      _(data[:accessories]).must_be_empty
    end

    it 'should contain one film roll' do
      _(data[:rolls].length).must_equal 1
    end

    describe 'the film roll' do
      let(:roll) { data[:rolls].first }

      it 'should have the expected roll id' do
        _(roll[:id]).must_equal 'A0012'
      end
      it 'should have the expected film type' do
        _(roll[:film]).must_equal 'Ilford Delta 100'
      end
      it 'should have the expected film speed' do
        _(roll[:speed]).must_equal 100
      end
      it 'should have the expected camera type' do
        _(roll[:camera]).must_equal 'Voigtländer Bessa R2M'
      end
      it 'should have the expected load date' do
        _(roll[:load]).must_equal Time.new(2016, 3, 28, 15, 16, 36, '+00:00')
      end
      it 'should have the expected unload date' do
        _(roll[:unload]).must_equal Time.new(2016, 5, 21, 14, 13, 15, '+00:00')
      end

      it 'should have one frame' do
        _(roll[:frames].length).must_equal 1
      end

      describe 'the frame' do
        let(:frame) { roll[:frames].first }

        it 'should have the expected lens type' do
          _(frame[:lens]).must_equal 'Color Skopar 35/2.5 Pancake II'
        end
        it 'should have the expected aperture' do
          _(frame[:aperture]).must_equal 5.6
        end
        it 'should have the expected shutter speed' do
          _(frame[:shutter_speed]).must_equal Rational(1, 500)
        end
        it 'should have the expected compensation' do
          _(frame[:compensation]).must_equal 0.0
        end
        it 'should have the expected accessory type' do
          _(frame[:accessory]).must_equal ''
        end
        it 'should have the expected date' do
          _(frame[:date]).must_equal Time.new(2016, 5, 13, 14, 12, 40, '+00:00')
        end
        it 'should have the expected note' do
          _(frame[:note]).must_equal ''
        end
        it 'should have the expected position' do
          _(frame[:position]).must_equal Geokit::LatLng.new(57.700767, 11.953715)
        end
      end
    end
  end
end
