$LOAD_PATH.push File.expand_path('../lib', __FILE__)
require 'login_cookie/version'

Gem::Specification.new do |s|
  s.name        = 'login_cookie'
  s.version     = LoginCookie::VERSION
  s.authors     = ['Dennis Rogenius', 'Lennart Fridén', 'Mikael Amborn', 'Karl Eklund', 'Victoria Wagman']
  s.email       = ['backend@magplus.com']
  s.homepage    = 'http://www.magplus.com'
  s.summary     = 'Mag+ Login Cookie'
  s.description = 'Gem for managing login cookies for single signon'

  s.rubyforge_project = 'login_cookie'

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ['lib']

  s.add_runtime_dependency 'multi_json'

  s.add_development_dependency 'byebug'
  s.add_development_dependency 'codeclimate-test-reporter'
  s.add_development_dependency 'rake'
  s.add_development_dependency 'rspec'
  s.add_development_dependency 'rspec-its'
  s.add_development_dependency 'timecop'
end
