require 'simplecov' if ENV['CI'] || ENV['COVERAGE']

require 'minitest/reporters'
Minitest::Reporters.use! Minitest::Reporters::SpecReporter.new
