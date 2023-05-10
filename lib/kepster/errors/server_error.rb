# frozen_string_literal: true
module Kepster
  module Errors
    class ServerError < StandardError
      def initialize(msg = "Server error")
        super
      end
    end
  end
end