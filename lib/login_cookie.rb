require "login_cookie/version"

require 'base64'
require 'digest'
require 'json'
require 'time'

module LoginCookie
  autoload :Config, 'login_cookie/config'
  autoload :Cookie, 'login_cookie/cookie'
  autoload :InvalidDigest, 'login_cookie/invalid_digest'
  autoload :InvalidVersion, 'login_cookie/invalid_version'
  autoload :Rails, 'login_cookie/rails'

  class << self
    def config
      @@config ||= Config.new('default', 1814400, 'magplus_session', '.magplus.dev')
    end

    def generate(user)
      Cookie.new(user).payload
    end

    def authenticate(cookie)
      Cookie.parse(cookie).user
    end
  end
end
