if ENV['CI']
  require 'simplecov_json_formatter'
  SimpleCov.formatter = SimpleCov::Formatter::JSONFormatter
end

SimpleCov.start do
  load_profile  'test_frameworks'
  command_name  'MiniTest'
  coverage_dir  'coverage'
  merge_timeout 3600

  track_files '{bin/*,lib/**/*.rb}'
  add_group   'Binaries',  'bin'
  add_group   'Libraries', 'lib'
  add_filter  'test'
end
