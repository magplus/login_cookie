require 'spec_helper'

describe LoginCookie::CookieParser do
  let(:time) { Time.parse('2001-01-01 00:00:00 UTC').utc }
  let(:payload_valid_in_2001) { "eyJlbWFpbCI6InRlc3QiLCJ2ZXJzaW9uIjoiMC40LjAiLCJleHBpcmVzX2F0\nIjoiMjAwMS0wMS0yMiAwMDowMDowMCBVVEMiLCJ2ZXJzaW9uIjoiMC40LjAi\nLCJleHBpcmVzX2F0IjoiMjAwMS0wMS0yMiAwMDowMDowMCBVVEMifQ==\n.95ab62cefdc3e9f392dee50518741608acf01f53fa0df8b758bb4f73d459305f" }

  before { Timecop.freeze(time) }
  after { Timecop.return }

  describe '.parse' do
    it 'returns a hash of the cookie payload' do
      expected_content = { 'email' => 'test', 'version' => LoginCookie::VERSION, 'expires_at' => (time + LoginCookie.config.ttl).to_s }
      expect(LoginCookie::CookieParser.parse(payload_valid_in_2001)).to eq expected_content
    end

    it 'raises an error if the payload digest does not match the content' do
      expect { LoginCookie::CookieParser.parse('e30K.asd') }.to raise_error(LoginCookie::InvalidDigest)
    end

    it 'raises an error if the payload was generated with another version' do
      error_version = "eyJlbWFpbCI6InRlc3QiLCJ2ZXJzaW9uIjoiMC4yLjMiLCJleHBpcmVzX2F0\nIjoiMjAwMS0wMS0yMSAyMzowMDowMCBVVEMifQ==\n.012a3453ec220c230a0154579b02660d2a7d4bef712282fc5b4dad3e9298bc7a"
      expect { LoginCookie::CookieParser.parse(error_version) }.to raise_error(LoginCookie::InvalidVersion)
    end

    it 'raises an error if the payload has expired' do
      Timecop.return
      expect { LoginCookie::CookieParser.parse(payload_valid_in_2001) }.to raise_error(LoginCookie::ExpiredCookie)
    end
  end
end
