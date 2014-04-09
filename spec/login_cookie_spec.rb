require 'spec_helper'

describe LoginCookie do
  describe '.config' do
    subject { LoginCookie.config }

    its(:secret) { should == 'default' }
    its(:ttl)    { should == 1814400 }
    its(:name)   { should == 'magplus_session' }
    its(:domain) { should == '.magplus.dev' }
  end

  describe '.generate' do
    it 'generates a new payload from the given hash' do
      contents = { 'test' => true }
      expected_payload = LoginCookie::CookieGenerator.generate(contents)
      expect(LoginCookie.generate(contents)).to eq expected_payload
    end
  end

  describe '.parse' do
    it 'parses the given payload to a hash' do
      payload = "eyJ0ZXN0Ijp0cnVlLCJ2ZXJzaW9uIjoiMC40LjAiLCJleHBpcmVzX2F0Ijoi\nMjAxNC0wNC0zMCAwOToyMzoxOSBVVEMifQ==\n.f312b79134be83150ff94606ef7a219e3c6b460e990271b119ef7ee9c4399397"
      Timecop.freeze(Time.parse '2014-03-01') do
        expected_content = LoginCookie::CookieParser.parse(payload)
        expect(LoginCookie.parse(payload)).to eq expected_content
      end
    end
  end
end
