require_relative './http'

module Facebook
  module AccountKit
    class TokenExchanger
      def initialize(authorization_code, app_id, app_secret)
        @authorization_code = authorization_code
        @app_id = app_id
        @app_secret = app_secret
      end

      def fetch_access_token
        result = HTTP.get compose_url
        result['access_token']
      end

      private

      def params
        user_params = {
          grant_type: 'authorization_code',
          code: @authorization_code,
          access_token: app_access_token
        }

        URI.encode_www_form(user_params)
      end

      def compose_url
        URI(token_url + '?' + params)
      end

      def token_url
        "https://graph.accountkit.com/#{Configuration.account_kit_version}/access_token"
      end

      def app_access_token
        ['AA', @app_id, @app_secret].join('|')
      end
    end
  end
end
