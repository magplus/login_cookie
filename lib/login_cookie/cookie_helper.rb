module LoginCookie
  module CookieHelper
    def hexdigest encoded
      Digest::SHA2.hexdigest(encoded + LoginCookie.config.secret)
    end

    def encode uncoded
      Base64.encode64 uncoded
    end

    def decode encoded
      Base64.decode64 encoded
    end

    def separator
      '.'
    end

    def expires_at
      Time.now.utc + LoginCookie.config.ttl
    end
  end
end
