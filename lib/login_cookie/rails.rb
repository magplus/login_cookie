module LoginCookie
  module Rails
    def set_login_cookie(user)
      cookie = LoginCookie::Cookie.new(user)
      cookies[LoginCookie.config.name] = { :value => cookie.payload, :expires => cookie.expires_at, :domain => LoginCookie.config.domain, :secure => false }
    end
  end
end
