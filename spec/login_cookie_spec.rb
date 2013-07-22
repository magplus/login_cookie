require 'spec_helper'

describe LoginCookie do
  let(:user) { double :id => 101, :first_name => 'Arnold', :name => 'Schwarzenegger', :role => 'terminator', :email => 'hasta-la-vista-baby@skynet.mil', :phone => '+46-(0)71-666 666', :verified_at => Time.new(1984, 10, 26).utc }
  let(:cookie) { LoginCookie::Cookie.new(user) }

  describe '.config' do
    subject { LoginCookie.config }

    its(:secret) { should == 'default' }
    its(:ttl)    { should == 1814400 }
    its(:name)   { should == 'magplus_session' }
    its(:domain) { should == '.magplus.dev'}
  end

  describe '.generate' do
    it 'returns the payload of a cookie given a user' do
      LoginCookie.generate(user).should == cookie.payload
    end
  end

  describe '.authenticate' do
    it 'returns a user from a cookie with the given payload' do
      User.should_receive(:find).with(cookie.user_id).and_return user
      LoginCookie.authenticate(cookie.payload).should == cookie.user
    end
  end
end
