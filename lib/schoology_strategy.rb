# require 'omniauth-oauth'
#
# module OmniAuth
#   module Strategies
#     class Schoology < OmniAuth::Strategies::OAuth
#
#       option :client_options, {
#             :access_token_path => "/oauth/access_token",
#             :authorize_path => "/oauth/authorize",
#             :request_token_path => "/v1/oauth/request_token",
#             :site => "https://api.schoology.com/v1"
#           }
#
#     end
#   end
# end

require 'omniauth'

module OmniAuth
  module Strategies
    class Schoology
      include OmniAuth::Strategy

      # option :name,
      option :fields, [:name, :email]
      option :uid_field, :email

      # option :client_options, {
      #         :site => 'https://api.schoology.com/v1',
      #         :authorize_url => 'https://api.schoology.com/v1/oauth/authorize',
      #         :access_token_url => 'https://api.schoology.com/v1/oauth/access_token'
      #       }

      option :client_options, {
        :access_token_path => "/oauth/access_token",
        :authorize_path => "/oauth/authorize",
        :request_token_path => "/v1/oauth/request_token",
        :site => "https://api.schoology.com/v1"
      }


      # receive parameters from the strategy declaration and save them
      def initialize(app, key, secret, auth_redirect, options = {})
        @key = key
        @secret = secret
        @auth_redirect = auth_redirect
        super(app, options)
      end

      def authorize_params
        super.tap do |params|
          %w[consumer_key consumer_secret].each do |v|
            if request.params[v]
              params[v.to_sym] = request.params[v]
            end
          end
        end
      end

      def request_phase
        r = Rack::Response.new
        r.redirect '/auth/schoology/callback'
        r.finish
      end

      def callback_url
        full_host + script_name + callback_path
      end


      #
      # # redirect to the Schoology website
      # def request_phase
      #   r = Rack::Response.new
      #   r.redirect @auth_redirect
      #   r.finish
      # end
      #
      # def callback_phase
      #   uid, username, avatar, token = request.params["uid"], request.params["username"], request.params["avatar"], request.params["token"]
      #   sha1 = Digest::SHA1.hexdigest("a mix of  #{@secret}, #{uid}, #{username}, #{avatar}")
      #
      #   # check if the request comes from Schoology or not
      #   if sha1 == token
      #     @uid, @username, @avatar = uid, username, avatar
      #     # OmniAuth takes care of the rest
      #     super
      #   else
	    #      # OmniAuth takes care of the rest
      #     fail!(:invalid_credentials)
      #   end
      # end
      #
      # # normalize user's data according to http://github.com/intridea/omniauth/wiki/Auth-Hash-Schema
      # def auth_hash
      #   OmniAuth::Utils.deep_merge(super(), {
      #     'uid' => @uid,
      #     'user_info' => {
      #       'name'     => @username,
      #       'nickname' => @username,
      #       'image'    => @avatar
      #     }
      #   })
      # end
    end
  end
end
