if ENV['CODECLIMATE_REPO_TOKEN']
  require 'codeclimate-test-reporter'
  CodeClimate::TestReporter.start
end

require 'login_cookie'
require 'time'
require 'timecop'
require 'rspec/its'
