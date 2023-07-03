# frozen_string_literal: true
module Kepster
  module Client
    class Base
      include HTTParty
      base_uri ENV['KEPSTER_ENDPOINT']
      format :json

      
      def initialize
        @kepster_api_key = ENV['KEPSTER_API_KEY']
        @kepster_shared_secret = ENV['KEPSTER_SHARED_SECRET']
        @kepster_signing_key = ENV['KEPSTER_SIGNING_KEY']
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
