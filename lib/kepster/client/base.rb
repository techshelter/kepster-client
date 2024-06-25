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
        ordered_payload = deep_sort(payload)
        Kepster::Crypto::Verifier.new.call(
          query_string: query_string(ordered_payload),
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
        nested_hash_to_query_string(payload)
      end

      private

      def nested_hash_to_query_string(hash, prefix = nil)
        hash.flat_map do |k, v|
          key = prefix ? "#{prefix}[#{k}]" : k
          case v
          when Hash
            nested_hash_to_query_string(v, key)
          else
            "#{URI.encode_www_form_component(key)}=#{URI.encode_www_form_component(v.to_s)}"
          end
        end.join("&")
      end

      def deep_sort(hash)
        sorted_hash = hash.sort.to_h
        sorted_hash.each do |key, value|
          sorted_hash[key] = deep_sort(value) if value.is_a?(Hash)
        end
        sorted_hash
      end
    end
  end
end
