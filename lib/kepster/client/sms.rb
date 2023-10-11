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
        puts "token #{token}"
        response = self.class.post(path, headers: headers(token), query: payload)
        puts "response in kpester #{response.parsed_response}"
        raise Kepster::Errors::RegistrationNotAllowed if response.code != 201
        response.parsed_response
      end

      def validate_registration_otp(phone_number:, otp_sended:, group_id:)
        path = '/api/sms/register/token'
        payload = { phone_number:, otp_sended:, group_id: }
        token = x_kepster_token(payload, path)
        response = self.class.get(path, headers: headers(token), query: payload)
        puts "response in kpester #{response.parsed_response}"
        response.parsed_response
      end

      def authenticate(phone_number:, group_id:)
        path = '/api/sms/authenticate'
        payload = { phone_number:, group_id: }
        token = x_kepster_token(payload, path)
        response = self.class.post(path, headers: headers(token), query: payload)
        puts "response in kpester #{response.parsed_response}"
        response.parsed_response
      end

      def validate_auth_otp(phone_number:, otp_sended:, group_id:)
        path = '/api/sms/auth/token'
        payload = { phone_number:, otp_sended:, group_id: }
        token = x_kepster_token(payload, path)
        response = self.class.get(path, headers: headers(token), query: payload)
        puts "response in kpester #{response.parsed_response}"
        response.parsed_response
      end

      def logout(refresh_token)
        path ='/api/sms/logout'
        payload = { refresh_token:}
        token = x_kepster_token(refresh_token, path)
        response = self.class.delete(path, headers: headers(token), query: refresh_token)
        response.parsed_response
      end

      def resend_otp(phone_number:, group_id:)
        path = '/api/sms/resend-otp'
        payload = { phone_number:, group_id: }
        token = x_kepster_token(payload, path)
        response = self.class.post(path, headers: headers(token), query: payload)
        puts "response in kpester #{response.parsed_response}"
        response.parsed_response
      end

    end
  end
end