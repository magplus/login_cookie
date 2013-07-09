require 'spec_helper'

describe LoginCookie::Cookie do
  let(:user) { double :id => 101, :first_name => 'Arnold', :name => 'Schwarzenegger', :role => 'terminator', :email => 'hasta-la-vista-baby@skynet.mil', :phone => '+46-(0)71-666 666' }
  let(:time) { Time.parse("2029-01-01 00:00:00 UTC") }
  let(:cookie) { LoginCookie::Cookie.new user }

  before { Timecop.freeze(time) } # time is now 2029 AD
  after { Timecop.return }

  describe :attributes do
    let(:session_token) { '5489818a669613b2ed5c62fbaf2706fada817e26c98647d99bb8174ed24eb4b8' }
    let(:expires_at) { time + LoginCookie.config.ttl }

    subject { cookie }

    its(:user)          { should == user }
    its(:user_id)       { should == 101 }
    its(:role)          { should == 'terminator' }
    its(:name)          { should == 'Arnold Schwarzenegger' }
    its(:email)         { should == 'hasta-la-vista-baby@skynet.mil' }
    its(:phone)         { should == '+46-(0)71-666 666' }
    its(:verified)      { should == true }

    its(:expires_at)    { should == expires_at }
    its(:session_token) { should == session_token }

    its(:to_json)       { should == { :user_id => 101,
                                      :session_token => session_token,
                                      :name => 'Arnold Schwarzenegger',
                                      :email => 'hasta-la-vista-baby@skynet.mil',
                                      :phone => '+46-(0)71-666 666',
                                      :role => 'terminator',
                                      :verified => true,
                                      :expires_at => expires_at,
                                      :version => LoginCookie::VERSION }.to_json }

    # Remember to update the test payload below if you change LoginCookie::VERSION
    its(:payload) { should == "eyJ1c2VyX2lkIjoxMDEsInNlc3Npb25fdG9rZW4iOiI1NDg5ODE4YTY2OTYx\nM2IyZWQ1YzYyZmJhZjI3MDZmYWRhODE3ZTI2Yzk4NjQ3ZDk5YmI4MTc0ZWQy\nNGViNGI4IiwibmFtZSI6IkFybm9sZCBTY2h3YXJ6ZW5lZ2dlciIsImVtYWls\nIjoiaGFzdGEtbGEtdmlzdGEtYmFieUBza3luZXQubWlsIiwicGhvbmUiOiIr\nNDYtKDApNzEtNjY2IDY2NiIsInJvbGUiOiJ0ZXJtaW5hdG9yIiwidmVyaWZp\nZWQiOnRydWUsImV4cGlyZXNfYXQiOiIyMDI5LTAxLTIyIDAwOjAwOjAwIFVU\nQyIsInZlcnNpb24iOiIwLjIuMyJ9\n.2c6b942a846aafbb45c264f98e54a8b2f18c8df0bcd2f3206b7cff91d9a40d81" }
  end

  describe '.name' do
    it 'is only the name if first_name is blank' do
      user = double :id => 101, :first_name => "", :name => 'Schwarzenegger', :role => 'terminator', :email => 'hasta-la-vista-baby@skynet.mil', :phone => '+46-(0)71-666 666'
      cookie = LoginCookie::Cookie.new user
      cookie.name.should == 'Schwarzenegger'
    end
  
    it 'is only the name if first_name is nil' do
      user = double :id => 101, :first_name => nil, :name => 'Schwarzenegger', :role => 'terminator', :email => 'hasta-la-vista-baby@skynet.mil', :phone => '+46-(0)71-666 666'
      cookie = LoginCookie::Cookie.new user
      cookie.name.should == 'Schwarzenegger'
    end
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
