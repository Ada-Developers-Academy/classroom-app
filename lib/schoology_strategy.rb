require 'omniauth-oauth'

module OmniAuth
  module Strategies
    class Schoology < OmniAuth::Strategies::OAuth
      option :name, "schoology"

      option :client_options, {
            :access_token_path => "/oauth/access_token",
            :authorize_url => "https://schoology.com/oauth/authorize",
            :request_token_path => "/oauth/request_token",
            :site => "http://api.schoology.com/v1",
            # :authorize_site => "http://schoology.com",
            :http_method => :get
          }
        # def request_phase
        #   super
        # end
    end
  end
end

OmniAuth.config.add_camelization 'schoology', 'Schoology'
