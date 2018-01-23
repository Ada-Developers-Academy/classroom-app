require 'omniauth'

module OmniAuth
  module Strategies
    class Schoology
      include OmniAuth::Strategy

      option :fields, [:name, :email]
      option :uid_field, :email

      def request_phase
        r = Rack::Response.new
        r.redirect '/auth/schoology/callback'
        r.finish
      end

      # # receive parameters from the strategy declaration and save them
      # def initialize(app, secret, auth_redirect, options = {})
      #   @secret = secret
      #   @auth_redirect = auth_redirect
      #   super(app, :schoology, options)
      # end
      #
      # # redirect to the Schoology website
      # def request_phase
      #   r = Rack::Response.new
      #   r.redirect @auth_redirect
      #   r.finish
      # end
      #
      def callback_phase
        uid, username, avatar, token = request.params["uid"], request.params["username"], request.params["avatar"], request.params["token"]
        sha1 = Digest::SHA1.hexdigest("a mix of  #{@secret}, #{uid}, #{username}, #{avatar}")

        # check if the request comes from Schoology or not
        if sha1 == token
          @uid, @username, @avatar = uid, username, avatar
          # OmniAuth takes care of the rest
          super
        else
	         # OmniAuth takes care of the rest
          fail!(:invalid_credentials)
        end
      end

      # normalize user's data according to http://github.com/intridea/omniauth/wiki/Auth-Hash-Schema
      def auth_hash
        OmniAuth::Utils.deep_merge(super(), {
          'uid' => @uid,
          'user_info' => {
            'name'     => @username,
            'nickname' => @username,
            'image'    => @avatar
          }
        })
      end
    end
  end
end
