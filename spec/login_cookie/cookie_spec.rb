require 'spec_helper'

describe LoginCookie::Cookie do
  let(:user) { stub :id => 101, :name => 'Arnold', :role => 'terminator', :email => 'hasta-la-vista-baby@skynet.mil', :phone => '+46-(0)71-666 666' }
  let(:time) { Time.new(2029, 01, 01).utc }
  let(:cookie) { LoginCookie::Cookie.new user }

  before { Timecop.freeze(time) } # time is now 2029 AD
  after { Timecop.return }

  describe :attributes do
    let(:session_token) { 'f2447695d1242fdfc686a98b66055563103b9957a3a017090aec9669b9d5a8c8' }
    let(:expires_at) { time + LoginCookie.config.ttl }

    subject { cookie }

    its(:user)          { should == user }
    its(:user_id)       { should == 101 }
    its(:role)          { should == 'terminator' }
    its(:name)          { should == 'Arnold' }
    its(:email)         { should == 'hasta-la-vista-baby@skynet.mil' }
    its(:phone)         { should == '+46-(0)71-666 666' }
    its(:verified)      { should == true }

    its(:expires_at)    { should == expires_at }
    its(:session_token) { should == session_token }

    its(:to_json)       { should == { :user_id => 101,
                                      :session_token => session_token,
                                      :name => 'Arnold',
                                      :email => 'hasta-la-vista-baby@skynet.mil',
                                      :phone => '+46-(0)71-666 666',
                                      :role => 'terminator',
                                      :verified => true,
                                      :expires_at => expires_at,
                                      :version => LoginCookie::VERSION }.to_json }

    # Remember to update the test payload below if you change LoginCookie::VERSION
    its(:payload) { should == "eyJ1c2VyX2lkIjoxMDEsInNlc3Npb25fdG9rZW4iOiJmMjQ0NzY5NWQxMjQy\nZmRmYzY4NmE5OGI2NjA1NTU2MzEwM2I5OTU3YTNhMDE3MDkwYWVjOTY2OWI5\nZDVhOGM4IiwibmFtZSI6IkFybm9sZCIsImVtYWlsIjoiaGFzdGEtbGEtdmlz\ndGEtYmFieUBza3luZXQubWlsIiwicGhvbmUiOiIrNDYtKDApNzEtNjY2IDY2\nNiIsInJvbGUiOiJ0ZXJtaW5hdG9yIiwidmVyaWZpZWQiOnRydWUsImV4cGly\nZXNfYXQiOiIyMDI5LTAxLTIxIDIzOjAwOjAwIFVUQyIsInZlcnNpb24iOiIw\nLjIuMSJ9\n.8ddea0a56e326d4c5aef1b0bbe4c3c52e8cc3d2dfb9b52f6776514a247d2ceff" }
  end

  describe '.parse' do
    context 'given the parsed JSON is of a version not matching the gems version' do
      it 'raises an error' do
        LoginCookie::Cookie.should_receive(:valid_version?).and_return false
        expect { LoginCookie::Cookie.parse(cookie.payload) }.to raise_error LoginCookie::InvalidVersion
      end
    end

    context 'given a valid cookie payload for an existing user' do
      before { User.should_receive(:find).with(user.id).and_return(user) }
      subject { LoginCookie::Cookie.parse(cookie.payload) }

      it 'returns a new cookie object' do
        should be_instance_of(LoginCookie::Cookie)
      end

      it 'corresponds to the user found in the payload' do
        subject.user.should == user
      end
    end

    context "given a valid cookie payload for a user that doesn't exist" do
      it 'returns nil' do
        User.should_receive(:find).with(user.id).and_return(nil)
        LoginCookie::Cookie.parse(cookie.payload).should be_nil
      end
    end

    context 'given a cookie with an invalid digest' do
      it 'raises an error' do
        LoginCookie::Cookie.should_receive(:valid_digest?).and_return false
        expect { LoginCookie::Cookie.parse(cookie.payload) }.to raise_error LoginCookie::InvalidDigest
      end
    end
  end
end
