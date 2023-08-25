# frozen_string_literal: true
require 'uri'
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
        q = ::Rack::Utils.build_nested_query(payload)
        params = URI.decode_www_form(q).to_h
        URI.encode_www_form(params)
        # "register_params%5Bfirst_name%5D=Ecole%20de&register_params%5Blast_name%5D=Multimedia&register_params%5Bphone_number%5D=0759937799&register_params%5Bcore_group_id%5D=9bfceff4-2730-448c-bf1f-ed303e8d48dc"
      end
    end
  end
end
