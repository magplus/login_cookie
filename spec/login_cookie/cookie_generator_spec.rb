require 'spec_helper'

describe LoginCookie::CookieGenerator do
  let(:time) { Time.parse('2001-01-01 00:00:00 UTC').utc }

  before { Timecop.freeze(time) }
  after { Timecop.return }

  describe '.generate' do
    let(:contents) { { 'email' => 'test' } }
    subject(:generated) { LoginCookie::CookieGenerator.generate(contents) }

    it 'returns a payload for the given content' do
      expected_payload = "eyJlbWFpbCI6InRlc3QiLCJ2ZXJzaW9uIjoiMC4zLjAiLCJleHBpcmVzX2F0\nIjoiMjAwMS0wMS0yMiAwMDowMDowMCBVVEMifQ==\n.3cf283f1c92ffe0ae8ebe2eef686d83a90a46c853a33bd52354d01d19ef79c8c"
      expect(generated).to eq expected_payload
    end

    it 'appends the cookie version to the content' do
      parsed = LoginCookie::CookieParser.parse(generated)
      expect(parsed).to include 'version' => '0.3.0'
    end

    it 'appends the expires at timestamp to the content' do
      parsed = LoginCookie::CookieParser.parse(generated)
      expect(parsed).to include 'expires_at' => '2001-01-22 00:00:00 UTC'
    end
  end
end
