module CookieAuthentication
  def authorize_with_cookie(user)
    request.cookies[:magplus_session] = LoginCookie.generate(user)
  end
end
