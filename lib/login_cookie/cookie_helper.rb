module LoginCookie
  class CookieHelper
    class << self
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
    end
  end
end
