require 'test_helper'
require 'minitest/autorun'
require 'filmrolls/metadata'

describe 'Filmrolls::Metadata.load' do
  describe 'a creative-commons configuration' do
    let(:data) do
      @output ||= Filmrolls::Metadata.load(File.read('test/data/meta-creative-commons.yaml'))
    end

    it 'should have the correct author' do
      _(data[:author]).must_equal 'Simon Sigurdhsson'
    end

    it 'should have the correct copyright string' do
      _(data[:copyright]).must_equal '© Simon Sigurdhsson, %{year}. Some rights reserved.'
    end

    it 'should have the correct attribution url' do
      _(data[:author_url]).must_equal 'http://photography.sigurdhsson.org/'
    end

    it 'should have the correct license url' do
      _(data[:license_url]).must_equal 'https://creativecommons.org/licenses/by-nc/4.0/'
    end

    it 'should have the marked attribute' do
      _(data[:marked]).must_equal true
    end

    it 'should have the correct usage terms' do
      _(data[:usage_terms]).must_equal [
        'This work is licensed under the Creative Commons',
        'Attribution-NonCommercial 4.0 International License. To view a copy',
        'of this license, visit https://creativecommons.org/licenses/by-nc/4.0/',
        'or send a letter to Creative Commons, 171 Second Street, Suite 300,',
        'San Francisco, California, 94105, USA.'
      ].join(' ')
    end
  end

  describe 'a copyright configuration' do
    let(:data) do
      @output ||= Filmrolls::Metadata.load(File.read('test/data/meta-copyright.yaml'))
    end

    it 'should have the correct author' do
      _(data[:author]).must_equal 'Simon Sigurdhsson'
    end

    it 'should have the correct copyright string' do
      _(data[:copyright]).must_equal '© Simon Sigurdhsson, %{year}. All rights reserved.'
    end

    it 'should have no attribution url' do
      _(data.keys).wont_include :author_url
    end

    it 'should have no license url' do
      _(data.keys).wont_include :license_url
    end

    it 'should have the marked attribute' do
      data[:marked] = true
    end

    it 'should have no usage terms' do
      _(data.keys).wont_include :usage_terms
    end
  end

  describe 'a public domain configuration' do
    let(:data) do
      @output ||= Filmrolls::Metadata.load(File.read('test/data/meta-public-domain.yaml'))
    end

    it 'should have the correct author' do
      _(data[:author]).must_equal 'Simon Sigurdhsson'
    end

    it 'should have the correct copyright string' do
      _(data[:copyright]).must_equal '© Simon Sigurdhsson, %{year}. No rights reserved.'
    end

    it 'should have the correct attribution url' do
      _(data[:author_url]).must_equal 'http://photography.sigurdhsson.org/'
    end

    it 'should have the correct license url' do
      _(data[:license_url]).must_equal 'https://creativecommons.org/publicdomain/zero/1.0/'
    end

    it 'should not have the marked attribute' do
      data[:marked] = false
    end

    it 'should have the correct usage terms' do
      _(data[:usage_terms]).must_equal [
        'To the extent possible under law, Simon Sigurdhsson has waived',
        'all copyright and related or neighboring rights to this work.'
      ].join(' ')
    end
  end
end
