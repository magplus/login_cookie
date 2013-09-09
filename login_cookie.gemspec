# -*- encoding: utf-8 -*-
$:.push File.expand_path('../lib', __FILE__)
require 'login_cookie/version'

Gem::Specification.new do |s|
  s.name        = 'login_cookie'
  s.version     = LoginCookie::VERSION
  s.authors     = ['Dennis Rogenius, Lennart Fridén', 'Mikael Amborn', 'Karl Eklund', 'Victoria Wagman']
  s.email       = ['backend@magplus.com']
  s.homepage    = 'http://www.magplus.com'
  s.summary     = 'Mag+ Login Cookie'
  s.description = 'Gem for managing login cookies for single signon'

  s.rubyforge_project = 'login_cookie'

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ['lib']

  # specify any dependencies here; for example:
  # s.add_development_dependency 'rspec'
  # s.add_runtime_dependency 'rest-client'

  s.add_development_dependency 'rake'
  s.add_development_dependency 'rspec', '~> 2.13'
  s.add_development_dependency 'timecop'
  s.add_development_dependency 'debugger'
end
