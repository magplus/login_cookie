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
      payload = "eyJ0ZXN0Ijp0cnVlLCJ2ZXJzaW9uIjoiMC4zLjAiLCJleHBpcmVzX2F0Ijoi\nMjAxNC0wMy0xNyAxMToxMDozMiBVVEMifQ==\n.937fdeab404cf2ce240551c927b4569fafb495cdfdbdf370e2ca5d1c5cea0d19"
      expected_content = LoginCookie::CookieParser.parse(payload)
      expect(LoginCookie.parse(payload)).to eq expected_content
    end
  end
end
