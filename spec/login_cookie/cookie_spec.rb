require 'spec_helper'

describe LoginCookie::Cookie do
  let(:user) { stub id: 101, name: "Arnold", role: "terminator", email: 'hasta-la-vista-baby@skynet.mil' }
  let(:time) { Time.new(2029,01,01).utc }
  let(:cookie) { LoginCookie::Cookie.new user }

  before { Timecop.freeze(time) } # time is now 2029 AD
  after { Timecop.return }

  describe :attributes do
    let(:session_token) { "f2447695d1242fdfc686a98b66055563103b9957a3a017090aec9669b9d5a8c8" }
    let(:expires_at) { time + LoginCookie.config.ttl }

    subject { cookie }

    its(:user)          { should == user }
    its(:user_id)       { should == 101 }
    its(:role)          { should == "terminator" }
    its(:name)          { should == "Arnold" }
    its(:email)         { should == 'hasta-la-vista-baby@skynet.mil'}

    its(:expires_at)    { should == expires_at }
    its(:session_token) { should == session_token }

    its(:to_json)       { should == {user_id: 101, session_token: session_token, name: "Arnold", email: 'hasta-la-vista-baby@skynet.mil', role: "terminator", expires_at: expires_at, version: LoginCookie::VERSION }.to_json }

    # Remember to update the test payload below if you change LoginCookie::VERSION
    its(:payload)       { should == "eyJ1c2VyX2lkIjoxMDEsInNlc3Npb25fdG9rZW4iOiJmMjQ0NzY5NWQxMjQy\nZmRmYzY4NmE5OGI2NjA1NTU2MzEwM2I5OTU3YTNhMDE3MDkwYWVjOTY2OWI5\nZDVhOGM4IiwibmFtZSI6IkFybm9sZCIsImVtYWlsIjoiaGFzdGEtbGEtdmlz\ndGEtYmFieUBza3luZXQubWlsIiwicm9sZSI6InRlcm1pbmF0b3IiLCJleHBp\ncmVzX2F0IjoiMjAyOS0wMS0yMSAyMzowMDowMCBVVEMiLCJ2ZXJzaW9uIjoi\nMC4xLjAifQ==\n.5eeac18ef912ecae3753960f5e492eb4fd4a15d39a5aecf8f23498e4c89eda60" }
  end

  describe ".parse" do
    context "given the parsed JSON is of a version not matching the gems version" do
      before { LoginCookie::Cookie.should_receive(:valid_version?).and_raise LoginCookie::InvalidVersion }
      
      it "should raise an error" do
        lambda { LoginCookie::Cookie.parse(cookie.payload) }.should raise_error      
      end
    end
    
    context "given a valid cookie payload for an existing user" do
      before { User.should_receive(:find).with(user.id).and_return(user) }
      subject {  LoginCookie::Cookie.parse(cookie.payload) }

      it "should return a new cookie object" do
        should be_instance_of(LoginCookie::Cookie)
      end

      it "should correspond to the user found in the payload" do
        subject.user.should == user
      end
    end

    context "given a valid cookie payload for a user that doesn't exist" do
      before { User.should_receive(:find).with(user.id).and_return(nil) }

      it "should return nil" do
        LoginCookie::Cookie.parse(cookie.payload).should be_nil
      end
    end

    context "given a cookie with an invalid digest" do
      before { LoginCookie::Cookie.should_receive(:valid_digest?).and_raise LoginCookie::InvalidDigest }
      it "should raise an error" do
        lambda { LoginCookie::Cookie.parse(cookie.payload) }.should raise_error
      end
    end
  end
end
