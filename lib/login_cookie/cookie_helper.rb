module LoginCookie
  class CookieHelper
    def self.hexdigest(encoded)
      Digest::SHA2.hexdigest(encoded + LoginCookie.config.secret)
    end

    def self.encode(uncoded)
      Base64.encode64 uncoded
    end

    def self.decode(encoded)
      Base64.decode64 encoded
    end

    def self.separator
      '.'
    end
  end
end
