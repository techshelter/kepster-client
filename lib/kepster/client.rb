# frozen_string_literal: true

require "bundler/setup"
require "httparty"
require "rack"
require "pathname"
require 'dotenv/load'
require_relative "client/version"
require_relative "client/base"
require_relative "client/email"
require_relative "client/sms"
require_relative "crypto/verifier"
require_relative "errors/registration_not_allowed"
require_relative "errors/invalid_action"

module Kepster
  module Client
    class Error < StandardError; end
    # Your code goes here...
  
    def self.root
      Pathname.new File.expand_path('../../', __dir__)
    end
  end
end
