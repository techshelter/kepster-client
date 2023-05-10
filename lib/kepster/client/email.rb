# frozen_string_literal: true
# create a module email for kepster client with httparty
module Kepster
  module Client
    class Email
      include HTTParty
      base_uri ENV['KEPSTER_ENDPOINT']
      format :json

      
      def initialize
        @kepster_api_key = ENV['KEPSTER_API_KEY']
        @kepster_shared_secret = ENV['KEPSTER_SHARED_SECRET']
        @kepster_signing_key = ENV['KEPSTER_SIGNING_KEY']
      end

      def register(first_name:, last_name:, email:, core_group_id:, redirect_url:)
        path = '/api/email/register'
        payload = {
          "register_params" => 
          { first_name:, last_name:, email:, core_group_id:, redirect_url: }
        }
        token = x_kepster_token(payload, path)
        response = self.class.post(path, headers: headers(token), query: payload)
        raise Kepster::Errors::RegistrationNotAllowed if response.code != 201
        response.parsed_response
      end

      def authenticate(email:, group_id:, redirect_url:)
        path = '/api/email/authenticate'
        payload = { email:, group_id:, redirect_url: }
        token = x_kepster_token(payload, path)
        response = self.class.post(path, headers: headers(token), query: payload)
        response.parsed_response
      end

      def logout(refresh_token)
        path = '/api/email/logout'
        payload = { refresh_token:}
        token = x_kepster_token(payload, path)
        self.class.delete(path, headers: headers(token), query: payload)
      end

      private

      def x_kepster_token(payload, path)
        Kepster::Crypto::Verifier.new.call(
          query_string: query_string(payload),
          resource_path: path,
          shared_secret: @kepster_shared_secret
        )
      end

      def headers(token)
        { 
          'x-kepster-token' => token,
          'x-kepster-key' => @kepster_api_key,
          'Content-Type' => 'application/json'
        }
      end

      def query_string(payload)
        ::Rack::Utils.build_nested_query(payload)
      end
    end
  end
end