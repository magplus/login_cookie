require 'login_cookie/version'

require 'base64'
require 'digest'
require 'time'

require 'multi_json'

module LoginCookie
  autoload :Config, 'login_cookie/config'
  autoload :CookieGenerator, 'login_cookie/cookie_generator'
  autoload :CookieParser, 'login_cookie/cookie_parser'
  autoload :CookieHelper, 'login_cookie/cookie_helper'

  autoload :InvalidDigest, 'login_cookie/invalid_digest'
  autoload :InvalidVersion, 'login_cookie/invalid_version'
  autoload :ExpiredCookie, 'login_cookie/expired_cookie'

  class << self
    def config
      @@config ||= Config.new('default', 1814400, 'magplus_session', '.magplus.dev')
    end

    def generate contents
      LoginCookie::CookieGenerator.generate contents
    end

    def parse payload
      LoginCookie::CookieParser.parse payload
    end
  end
end
