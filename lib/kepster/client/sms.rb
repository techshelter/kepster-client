# frozen_string_literal: true
# create a module email for kepster client with httparty
module Kepster
  module Client
    class SMS < Base

      def register(first_name:, last_name:, phone_number:, core_group_id:, fields:)
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

      # def authenticate(email:, group_id:, redirect_url:)
      #   path = '/api/email/authenticate'
      #   payload = { email:, group_id:, redirect_url: }
      #   token = x_kepster_token(payload, path)
      #   response = self.class.post(path, headers: headers(token), query: payload)
      #   response.parsed_response
      # end

      # def logout(refresh_token)
      #   path = '/api/email/logout'
      #   payload = { refresh_token:}
      #   token = x_kepster_token(payload, path)
      #   self.class.delete(path, headers: headers(token), query: payload)
      # end

      # def validate_token(token, user_id)
      #   path = "/api/email/token"
      #   payload = {code: token, auth_user_id: user_id}
      #   token = x_kepster_token(payload, path)
      #   self.class.get(path, headers: headers(token), query: payload)
      # end

      # def refresh_token(refresh_token)
      #   path = "/api/email/token"
      #   payload = {refresh_token:}
      #   token = x_kepster_token(payload, path)
      #   self.class.get(path, headers: headers(token), query: payload)
      # end
    end
  end
end