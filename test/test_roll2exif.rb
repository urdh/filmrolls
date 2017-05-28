if ENV['CI']
  require('codacy-coverage')
  Codacy::Reporter.start
end

# This file intentionally left (almost) blank.
