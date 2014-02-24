require 'spec_helper'

describe LoginCookie::CookieGenerator do
  let(:time) { Time.parse('2001-01-01 UTC').utc }

  before { Timecop.freeze(time) }
  after { Timecop.return }

  describe '.generate' do
    let(:contents) { { 'email' => 'test' } }
    subject(:generated) { LoginCookie::CookieGenerator.generate(contents) }

    it 'returns a payload for the given content' do
      expected_payload = "eyJlbWFpbCI6InRlc3QiLCJ2ZXJzaW9uIjoiMC4zLjAiLCJleHBpcmVzX2F0\nIjoiMjAwMS0wMS0yMSAyMzowMDowMCBVVEMifQ==\n.feb4e88ac61f1faaf4ef078350e340339e9316d591bf043e600b597f890990b0"
      expect(generated).to eq expected_payload
    end

    it 'appends the cookie version to the content' do
      parsed = LoginCookie::CookieParser.parse(generated)
      expect(parsed).to include 'version' => '0.3.0'
    end

    it 'appends the expires at timestamp to the content' do
      parsed = LoginCookie::CookieParser.parse(generated)
      expect(parsed).to include 'expires_at' => '2001-01-21 23:00:00 UTC'
    end
  end
end
