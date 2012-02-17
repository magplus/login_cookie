require 'login_cookie'
require 'time'
require 'timecop'

# Dummy class for the spec
class User
  def self.find(id)
    id
  end
end
