# frozen_string_literal: true
# create a module email for kepster client with httparty
module Kepster
  module Client
    class SMS < Base

      def register(first_name:, last_name:, phone_number:, core_group_id:)
        path = '/api/sms/register'
        payload = {
          "register_params" => 
          { first_name:, last_name:, phone_number:, core_group_id: }
        }
        token = x_kepster_token(payload, path)
        response = self.class.post(path, headers: headers(token), query: payload)
        raise Kepster::Errors::RegistrationNotAllowed if response.code != 201
        response.parsed_response
      end

      def validate_registration_otp(phone_number:, otp_sended:, group_id:)
        path = '/api/sms/register/token'
        payload = { phone_number:, otp_sended:, group_id: }
        token = x_kepster_token(payload, path)
        response = self.class.get(path, headers: headers(token), query: payload)
        response.parsed_response
      end

      def authenticate(phone_number:, group_id:)
        path = '/api/sms/authenticate'
        payload = { phone_number:, group_id: }
        token = x_kepster_token(payload, path)
        response = self.class.post(path, headers: headers(token), query: payload)
        response.parsed_response
      end

    end
  end
end