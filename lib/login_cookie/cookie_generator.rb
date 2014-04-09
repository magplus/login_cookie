module LoginCookie
  class CookieGenerator
    attr_reader :json

    def self.generate(content)
      new(content).generate
    end

    def initialize(content)
      @json = MultiJson.dump content.merge(cookie_parameters)
    end

    def generate
      [CookieHelper.encode(json), CookieHelper.hexdigest(CookieHelper.encode(json))].join CookieHelper.separator
    end

    private

    def cookie_parameters
      {
        version: LoginCookie::VERSION,
        expires_at: expires_at
      }
    end

    def expires_at
      Time.now.utc + LoginCookie.config.ttl
    end
  end
end
