# frozen_string_literal: true
module Kepster
  module Errors
    class InvalidAction < StandardError
      def initialize(msg = "Invalid action")
        super
      end
    end
  end
end