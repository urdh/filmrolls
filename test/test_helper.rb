if ENV['CI']
  require 'codacy-coverage'
  Codacy::Reporter.start
else
  require 'minitest/reporters'
  Minitest::Reporters.use! Minitest::Reporters::SpecReporter.new
end
