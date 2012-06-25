module LoginCookie
  class Cookie
    attr_accessor :user_id, :user, :role, :name, :email, :expires_at, :phone, :verified, :session_token

    def initialize(user)
      self.user = user
      self.user_id = user.id
      self.name = user.name
      self.email = user.email
      self.phone = user.phone
      self.role = user.role
      self.verified = !user.verified_at.nil?
    end

    def payload
      jsonb64 = Base64.encode64(self.to_json)
      [jsonb64, Cookie.hexdigest(jsonb64) ].join Cookie.separator
    end

    def to_json
      { :user_id => user_id,
        :session_token => session_token,
        :name => name,
        :email => email,
        :phone => phone,
        :role => role,
        :verified => verified,
        :expires_at => expires_at,
        :version => LoginCookie::VERSION }.to_json
    end

    def expires_at
      @expires_at ||= Time.now.utc + LoginCookie.config.ttl
    end

    def session_token
      @session_token ||= Digest::SHA2.hexdigest [self.user_id, self.expires_at.to_i].join
    end

    def self.parse(payload)
      return unless user = find_user(payload)
      new(user)
    end

    private # doesn't really make the methods private, but just to separate the helpers from the interface

    def self.separator
      '.'
    end

    def self.hexdigest(base64json)
      Digest::SHA2.hexdigest(base64json + LoginCookie.config.secret)
    end

    def self.find_user(payload)
      base64json, hexdigest = payload.split(Cookie.separator)
      User.find user_id_from_cookie(base64json, hexdigest)
    end

    def self.user_id_from_cookie(base64json, hexdigest)
      return nil unless valid_digest?(base64json, hexdigest)

      json = JSON.parse(Base64.decode64(base64json))

      return nil unless valid_version?(json['version'])
      return nil if expired?(json['expires_at'])

      json['user_id']
    end

    def self.valid_digest?(base64json, hexdigest)
      valid = hexdigest(base64json) == hexdigest
      valid or raise LoginCookie::InvalidDigest.new("Cookie digest did not match, have you set the correct secret?")
    end

    def self.valid_version?(version)
      version == LoginCookie::VERSION
      version or raise LoginCookie::InvalidVersion.new("Cookie was created with another version of LoginCookie.")
    end

    def self.expired?(date)
      Time.parse(date) < Time.now.utc
    end

  end
end
