# frozen_string_literal: true
module Kepster
  module Errors
    class RegistrationNotAllowed < StandardError
      def initialize(msg = "Registration not allowed")
        super
      end
    end
  end
end