require 'spec_helper'

describe LoginCookie::CookieParser do
  let(:time) { Time.parse('2001-01-01 UTC').utc }

  before { Timecop.freeze(time) }
  after { Timecop.return }

  describe '.parse' do
    it 'returns a hash of the cookie payload' do
      payload = "eyJlbWFpbCI6InRlc3QiLCJ2ZXJzaW9uIjoiMC4zLjAiLCJleHBpcmVzX2F0\nIjoiMjAwMS0wMS0yMSAyMzowMDowMCBVVEMiLCJ2ZXJzaW9uIjoiMC4zLjAi\nLCJleHBpcmVzX2F0IjoiMjAwMS0wMS0yMSAyMzowMDowMCBVVEMifQ==\n.f59e9d0db210bc5e72d26e6ee3dd408a7f65a61670e3d77e5a6cc33753a9e83c"
      expected_content = { 'email' => 'test', 'version' => LoginCookie::VERSION, 'expires_at' => (time+LoginCookie.config.ttl).to_s }
      expect(LoginCookie::CookieParser.parse(payload)).to eq expected_content
    end

    it 'raises an error if the payload digest doesnt match the content' do
      expect { LoginCookie::CookieParser.parse("e30K.asd") }.to raise_error(LoginCookie::InvalidDigest)
    end

    it 'raises an error if the payload was generated with another version' do
      error_version = "eyJlbWFpbCI6InRlc3QiLCJ2ZXJzaW9uIjoiMC4yLjMiLCJleHBpcmVzX2F0\nIjoiMjAwMS0wMS0yMSAyMzowMDowMCBVVEMifQ==\n.012a3453ec220c230a0154579b02660d2a7d4bef712282fc5b4dad3e9298bc7a"
      expect { LoginCookie::CookieParser.parse(error_version) }.to raise_error(LoginCookie::InvalidVersion)
    end

    it 'raises an error if the payload has expired' do
      Timecop.return
      error_expired = "eyJlbWFpbCI6InRlc3QiLCJ2ZXJzaW9uIjoiMC4zLjAiLCJleHBpcmVzX2F0\nIjoiMjAwMS0wMS0yMSAyMzowMDowMCBVVEMifQ==\n.feb4e88ac61f1faaf4ef078350e340339e9316d591bf043e600b597f890990b0"
      expect{ LoginCookie::CookieParser.parse(error_expired) }.to raise_error(LoginCookie::ExpiredCookie)
    end
  end
end
