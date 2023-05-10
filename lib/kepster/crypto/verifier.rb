# frozen_string_literal: true
require 'digest'
module Kepster
  module Crypto
    class Verifier
      def call(query_string:, resource_path:, shared_secret:)
        timestamp = Time.now.getutc.to_i.to_s
        hash_input = "#{timestamp}$#{resource_path}$#{query_string}"
        hash_output = OpenSSL::HMAC.hexdigest(OpenSSL::Digest.new('sha256'), shared_secret, hash_input)
        token = timestamp + ":" + hash_output
        token.upcase
      end
    end
  end
end