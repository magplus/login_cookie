require "login_cookie/version"

require 'base64'
require 'digest'
require 'json'
require 'time'

module LoginCookie
  autoload :Config, 'login_cookie/config'
  autoload :Cookie, 'login_cookie/cookie'

  class << self
    def config
      @@config ||= Config.new('default', 1814400)
    end

    def generate(user)
      Cookie.new(user).payload
    end

    def authenticate(cookie)
      Cookie.parse(cookie).user
    end
  end
end
