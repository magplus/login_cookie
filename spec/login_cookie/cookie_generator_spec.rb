require 'spec_helper'

describe LoginCookie::CookieGenerator do
  let(:time) { Time.parse('2001-01-01 00:00:00 UTC').utc }

  before { Timecop.freeze(time) }
  after { Timecop.return }

  describe '.generate' do
    let(:contents) { { 'email' => 'test' } }
    subject(:generated) { LoginCookie::CookieGenerator.generate(contents) }

    it 'returns a payload for the given content' do
      expected_payload = "eyJlbWFpbCI6InRlc3QiLCJ2ZXJzaW9uIjoiMC40LjAiLCJleHBpcmVzX2F0\nIjoiMjAwMS0wMS0yMiAwMDowMDowMCBVVEMifQ==\n.a4aa25874e4729450f8142c883591350a0e19c0fdabca8a6d289d3637ff21e02"
      expect(generated).to eq expected_payload
    end

    it 'appends the cookie version to the content' do
      parsed = LoginCookie::CookieParser.parse(generated)
      expect(parsed).to include 'version' => '0.4.0'
    end

    it 'appends the expires at timestamp to the content' do
      parsed = LoginCookie::CookieParser.parse(generated)
      expect(parsed).to include 'expires_at' => '2001-01-22 00:00:00 UTC'
    end
  end
end
