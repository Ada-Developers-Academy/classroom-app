require 'httparty'

class Schoology
  BASE_URL = "http://api.schoology.com/v1/"

  def self.retrieve_courses(token, token_secret)
    request_url = BASE_URL + "courses"

    response = HTTParty.get(request_url,
      headers: self.auth(token, token_secret))

    if response.code == 200
      return response
    else
      # error
      raise
    end
  end

  def self.auth(token, token_secret)
    {
      "realm" => "Schoology API",
      "user-agent" => "rails",
      "oauth_version"=> "1.0",
      "oauth_consumer_key" => ENV["SCHOOLOGY_CONSUMER_KEY"],
      "oauth_token" => token,
      "oauth_signature" => ENV["SCHOOLOGY_CONSUMER_SECRET"] + token_secret,
      "oauth_signature_method" => 'PLAINTEXT',
      # ActionController::HttpAuthentication::Digest.nonce(Rails.configuration.secret_key_base),
      "oauth_nonce" => ActionController::HttpAuthentication::Digest.nonce(token),
      "oauth_timestamp" => Time.now.to_i.to_s
    }
  end
end
