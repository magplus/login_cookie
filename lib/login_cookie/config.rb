module LoginCookie
  class Config < Struct.new(:secret, :ttl)
  end
end
