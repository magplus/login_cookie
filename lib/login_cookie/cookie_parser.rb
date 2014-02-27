module LoginCookie
  class CookieParser
    attr_reader :payload, :encoded, :digest

    def self.parse payload
      new(payload).parse
    end

    def initialize(payload)
      @payload = payload
      @encoded, @digest = payload.split(CookieHelper.separator)
    end

    def parse
      json = MultiJson.load CookieHelper.decode(encoded)

      case
      when invalid_digest?
        raise LoginCookie::InvalidDigest.new('Cookie digest did not match, have you set the correct secret?')
      when invalid_version?(json['version'])
        raise LoginCookie::InvalidVersion.new('Cookie was created with another version of LoginCookie.')
      when expired?(json['expires_at'])
        raise LoginCookie::ExpiredCookie.new('Cookie validity has expired.')
      else
        json
      end
    end

    private

    def invalid_digest?
      CookieHelper.hexdigest(encoded) != digest
    end

    def invalid_version? ver
      LoginCookie::VERSION != ver
    end

    def expired?(time)
      Time.parse(time) < Time.now.utc
    end
  end
end
