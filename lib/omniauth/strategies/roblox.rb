# frozen_string_literal: true

require 'base64'
require 'json'
require 'net/http'
require 'omniauth-oauth2'
require 'uri'

module OmniAuth
  module Strategies
    class Roblox < OmniAuth::Strategies::OAuth2
      option :name, 'roblox'

      option :client_options,
             authorize_url: 'v1/authorize',
             site: 'https://apis.roblox.com/oauth',
             token_url: 'v1/token'

      option :authorize_options, %i[consent login selectAccount]
      option :image_type, 'headshot'
      option :skip_image, false

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
          image: image_url,
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

        return if @raw_info['name']

        user_api_res = Net::HTTP.get_response(URI("https://users.roblox.com/v1/users/#{uid}"))

        # The Roblox Users API returns usernames under the `name` property
        # Unlike the id_token where it is the display name
        return unless user_api_res.is_a?(Net::HTTPSuccess)

        api_data = JSON.parse(user_api_res.body)
        @raw_info['nickname'] = api_data['name']
        @raw_info['name'] = api_data['displayName']
      end

      # Roblox currently does not allow third parties to access user emails, this is only added for completeness
      def verified_email
        raw_info['email_verified'] ? raw_info['email'] : nil
      end

      def image_url # rubocop:disable Metrics
        return nil if options[:skip_image]

        url = 'https://thumbnails.roblox.com/v1/users/avatar'
        url_additions = {
          bust: '-bust',
          headshot: '-headshot'
        }
        uri = URI(url + url_additions[options[:image_type]])
        uri.query = URI.encode_www_form({
                                          userIds: raw_info['sub'],
                                          size: '720x720',
                                          format: 'Png',
                                          isCircular: 'false'
                                        })

        res = Net::HTTP.get_response(uri)
        data = JSON.parse(res.body).data.first

        res.is_a?(Net::HTTPSuccess) ? data.imageUrl : nil
      end
    end
  end
end
