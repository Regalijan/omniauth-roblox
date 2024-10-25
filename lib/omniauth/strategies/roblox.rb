# frozen_string_literal: true

require 'base64'
require 'json'
require 'omniauth-oauth2'

module OmniAuth
  module Strategies
    class Roblox < OmniAuth::Strategies::OAuth2
      option :name, 'roblox'

      option :client_options,
             authorize_url: 'v1/authorize',
             site: 'https://apis.roblox.com/oauth',
             token_url: 'v1/token'

      uid { raw_info['sub'] }

      info do
        {
          name: raw_info['name'],
          nickname: user_info['nickname'],
          image: raw_info['picture'],
          # This is provided in the `profile` claim, but is not included if the `profile` scope is not set
          urls: { website: "https://www.roblox.com/users/#{uid}/profile" }
        }
      end

      extra do
        { raw_info: raw_info }
      end

      def raw_info
        @raw_info ||= JSON.parse(
          Base64.urlsafe_decode64(
            access_token[:id_token].split('.')[1]
          )
        )
      end

      # Roblox currently does not allow third parties to access user emails, this is only added for completeness
      def verified_email
        raw_info['email_verified'] ? raw_info['email'] : nil
      end

      def callback_url
				options[:redirect_uri] || (full_host + script_name + callback_path)
      end
    end
  end
end
