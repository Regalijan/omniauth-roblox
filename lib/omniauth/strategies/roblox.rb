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

      option :authorize_options, %i[consent login selectAccount]

      def authorize_params # rubocop:disable Metrics/AbcSize
        super.tap do |params|
          options[:authorize_options].each do |k|
            params[k] = request.params[k.to_s] unless [nil, ''].include?(request.params[k.to_s])
          end

          session['omniauth.state'] = params[:state] if params[:state]
        end
      end

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
            access_token['id_token'].split('.')[1]
          )
        )
      end

      # Roblox currently does not allow third parties to access user emails, this is only added for completeness
      def verified_email
        raw_info['email_verified'] ? raw_info['email'] : nil
      end
    end
  end
end
