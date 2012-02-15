#require 'spec_helper'

describe LoginCookie do
  describe ".config" do
    subject { LoginCookie.config }

    its(:secret){ should == 'default' }
    its(:ttl){ should == 1814400 }
  end

  describe ".generate" do
    it "should return the payload of a cookie given a user"
  end

  describe ".authenticate" do
    it "should return a user given a payload of a cookie for the user"
  end
end
