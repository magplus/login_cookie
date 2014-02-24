module LoginCookie
  class CookieGenerator
    include CookieHelper

    attr_reader :json

    def self.generate content
      new(content).generate
    end

    def initialize content
      @json = MultiJson.dump content.merge(cookie_parameters)
    end

    def generate
      [encode(json), hexdigest(encode(json))].join separator
    end

    private

    def cookie_parameters
      {
        version: LoginCookie::VERSION,
        expires_at: expires_at
      }
    end
  end
end
