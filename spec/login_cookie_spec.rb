require 'spec_helper'

describe LoginCookie do
  let(:user) { stub id: 1, name: 'wassup', role: 'test', email: 'test@example.com' }
  let(:cookie) { LoginCookie::Cookie.new(user) }

  describe ".config" do
    subject { LoginCookie.config }

    its(:secret) { should == 'default' }
    its(:ttl)    { should == 1814400 }
    its(:name)   { should == 'magplus_session' }
    its(:domain) { should == '.magplus.dev'}
  end

  describe ".generate" do
    it "should return the payload of a cookie given a user" do
      LoginCookie.generate(user).should == cookie.payload
    end
  end

  describe ".authenticate" do
    it "should return a user from a cookie with the given payload" do
      User.should_receive(:find).with(cookie.user_id).and_return user
      LoginCookie.authenticate(cookie.payload).should == cookie.user
    end
  end
end
