module LoginCookie
  class Config < Struct.new(:secret, :ttl, :name, :domain)
  end
end
